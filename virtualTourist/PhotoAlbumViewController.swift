//
//  PhotoAlbumViewController.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// This is the secondary view controller that is displayed
// when a pin is selected.
// It is equivalent to the MovieListViewController class
// from the Favorite Actors app.
// (factor actors is step-5.5 of ios-persistence-2.0

import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate,
    MKMapViewDelegate,                                    // TODO: Verify that it's safe to delete the MKMapViewDelegate
    NSFetchedResultsControllerDelegate {
    
    // The selectedIndexes array keeps all of the indexPaths for cells that are selected.
    // The array is used inside cellForItemAtIndexPath to modify the alpha.
    
    var selectedIndexes = [NSIndexPath]()
    
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var removeSelectedPicturesButton: UIButton!
    
    
    var location: Pin!
    let regionRadius: CLLocationDistance = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the fetched results controller
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        if let error = error {
           print("Error performing initial fetch: \(error)")
        }
        
        removeSelectedPicturesButton.enabled = false
        updateBottomButton()
        setupMapView()
    }
    
    // TODO: Add a viewDidLayoutSubviews that sets the UICollectionViewFlowLayout()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if location.photos.isEmpty {
            FlickrClient.sharedInstance().getPhotosFromLatLonSearch(location)
                { (result, error) -> Void in
                    
                    
                    if let photosDictionaries = result as? [[String : AnyObject]] {
                        
                        // Parse the array of photos dictionaries
                        _ = photosDictionaries.map() { (dictionary: [String : AnyObject]) -> Photo in
                            let photo = Photo(dictionary: dictionary, context: self.sharedContext)
                           //  print(" *** Photo ****")
                           // print(photo.url)
                            // old code, before core data
                            // self.location.photos.append(photo)
                            // new code, with core data
                            // Add a photo to the array using the inverse relationship.
                           // photo.location = self.location
                            
                            // for future reference, you will remove a photo
                            // like this
                            // photo.location = nil
                            return photo
                        }
                        // _ = photos.map() {
                        //     self.location.photos.append($0)
                        // }
                        // Update the collection view on the main thread
                        performUIUpdatesOnMain {
                            self.collectionView.reloadData()
                            // TODO : enable
                            self.removeSelectedPicturesButton.enabled = true
                        }
                        
                        // Save the context
                        self.saveContext()
                    } else {
                        print("Download of Flickr Photo failed")
                    }
            }
        }
        
    }
    
    func setupMapView() {
        let annotation = MKPointAnnotation()
        
        let latitude = location.latitude.doubleValue
        let longitude = location.longitude.doubleValue
        
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        centerMapOnLocation(initialLocation)
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configureCell(cell: VTCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.imageView.image = Photo.getFlickrImage(photo)!
        // If the cell is selected then it's it's color is greyed out.
        if let _ = selectedIndexes.indexOf(indexPath) {
            cell.imageView.alpha = 0.05
        } else {
            cell.imageView.alpha = 1.0
        }
        // TODO: Add code to display a placeholder image before
        // the photo is displayed.
        // See Favorite Actors (ios-persistence-2.0, step 5.3,
        // CoreDataFavoriteActors, MovieListViewController for
        // an example.
    }
    
    // MARK: - UICollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        print(" number of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "VTCollectionViewCell"
        
        // TODO:
        
        // let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        // cell.imageView.image = Photo.getFlickrImage(photo)!
        //cell.imageView.image = location.photos[indexPath.row].flickrImage!
      //  cell.imageView.alpha = 0.5
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(" cell selected at: ", indexPath.row)
        removeSelectedPicturesButton?.titleLabel?.text = "Remove Selected Pictures"
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VTCollectionViewCell
        
        // Whenever a cell is tapped we will toggle it's presence in the selectedIndexes array
        if let index = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(index)
        } else {
            selectedIndexes.append(indexPath)
        }
        
        // Then reconfigure the cell
        
        configureCell(cell, atIndexPath: indexPath)
        
        // TODO: Update the bottom button
        updateBottomButton()
        
        //let CellIdentifier = "VTCollectionViewCell"
        
        
        // let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        // cell.imageView.alpha = 0.5
    }
    
    
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "staticPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = UIColor.blueColor()
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    */
    
    
    /*
    lazy var scratchContext: NSManagedObjectContext {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }
    */
    
    @IBAction func removeSelectedPictures(sender: UIButton) {
        print(" Remove Selected Photos")
        if selectedIndexes.isEmpty {
            print(" update the collection view")
        } else {
            deleteSelectedPhotos()
        }
    }
    
    func deleteSelectedPhotos() {
        var photosToDelete = [Photo]()
        
        for indexPath in selectedIndexes {
            photosToDelete.append(fetchedResultsController.objectAtIndexPath(indexPath) as! Photo)
        }
        
        for photo in photosToDelete {
            sharedContext.deleteObject(photo)
        }
        
        selectedIndexes = [NSIndexPath]()
    }
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        // Add a sort descriptor. This enforces a sort order on the results that are generated
        // In this case we want the events sored by their timeStamps.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        // This next line is a copied from the ColorCollection app.  It should probably
        // be in viewDidLoad instead.
        fetchedResultsController.delegate = self
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
    } ()
    
    // MARK: - Fetched Results Controller Delegate
    // Whenever changes are made to Core Data the following three methods are invoked.  This
    // first method is used to create three fresh arrays to record the index paths
    // that will be changed.
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // We are about to handle some new changes.  Start out with empty
        // arrays for each change type
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
        print(" in controllerWillChangeContent")
    }

    // The second method may be called multiple times, once for each Photo that is
    //added, deleted, or changed.
    // We store the index paths into the three arrays.
    func  controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            print("Insert a photo")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            print("Delete a photo")
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            print("Update an item.")
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            print("Move an item.  We don't expect to see this in this app.")
            break
        }
    }
    // This method is invoked after all the changes in the current batch have been collected
    // into the three index path arrays [insert, delete, adn update).  We now need to loop
    // through the arrays and perform the changes.
    // The most interesting thing about the method is the collection view's performBatchUpdates
    // method.  Notice that all of the changes are performed inside a closure that is handed to
    // the collection view.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        print("in controllerDidChangeContent")
        print("insertion count: \(insertedIndexPaths.count)")
        print("deletion count: \(deletedIndexPaths.count)")
        collectionView.performBatchUpdates({ () -> Void in
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            }, completion: nil)
     }
    
    // MARK: - Actions and Helpers
    func updateBottomButton() {
        if selectedIndexes.count > 0 {
            removeSelectedPicturesButton.titleLabel?.text = " - ABC - Remove Selected Photos"
            removeSelectedPicturesButton.enabled = true
        } else {
            removeSelectedPicturesButton.titleLabel?.text = " - ABC - New Collection"
            removeSelectedPicturesButton.enabled = false
        }
    }
}
