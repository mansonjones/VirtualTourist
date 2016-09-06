//
//  PhotoAlbumVC.swift
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

import CoreData
import MapKit
import UIKit

class PhotoAlbumVC: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate,
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
    
    // MARK: - Life Cycle
    
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
        
        fetchedResultsController.delegate = self

        updateBottomButton()
        setupMapView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that the cells take up 1/3 of the width,
        // with no space between them.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        // New Core Data
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        return stack!.context
    }()
    
    func saveContext() {
        // New Core Data
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        stack!.save()
        
    }
    
    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "location == %@", self.location)
        
        // Add a sort descriptor. This enforces a sort order on the results that are generated
        // In this case we want the events sored by their timeStamps.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
    } ()
    
    // MARK: - UICollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "VTCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VTCollectionViewCell
        
        // Whenever a cell is tapped we will toggle it's presence in the selectedIndexes array
        if let index = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(index)
        } else {
            selectedIndexes.append(indexPath)
        }
        
        // Then reconfigure the cell
        
        configureCell(cell, atIndexPath: indexPath)
        
        updateBottomButton()
    }
    
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
    }
    
    // The second method may be called multiple times, once for each Photo that is
    //added, deleted, or changed.
    // We store the index paths into the three arrays.
    func  controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
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
    
    @IBAction func removeSelectedPictures(sender: UIButton) {
        if selectedIndexes.isEmpty {
            deleteAllPhotos()
            loadPhotos()
        } else {
            deleteSelectedPhotos()
        }
    }
    
    func loadPhotos() {
        if location.photos.isEmpty {
            FlickrClient.sharedInstance().getPhotosFromLatLonSearch(location.latitude.doubleValue, longitude: location.latitude.doubleValue)
                { (result, error) -> Void in
                    
                    
                    if let photosDictionaries = result as? [[String : AnyObject]] {
                        
                        // Parse the array of photos dictionaries
                        _ = photosDictionaries.map() { (dictionary: [String : AnyObject]) -> Photo in
                            let photo = Photo(dictionary: dictionary, context: self.sharedContext)
                            photo.location = self.location
                            return photo
                        }
                        
                        // New Core Data
                        
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let stack = delegate.stack
                        stack!.save()

                        
                        
                        // Update the collection view on the main thread
                        performUIUpdatesOnMain {
                            self.collectionView.reloadData()
                            self.updateBottomButton()
                        }
                        
                        // Save the context
                        self.saveContext()
                    } else {
                        print("Download of Flickr Photo failed")
                    }
            }
        }
    }
    
    
    func deleteAllPhotos() {
        
        for photo in fetchedResultsController.fetchedObjects as! [Photo] {
            sharedContext.deleteObject(photo)
        }
        // New Core data
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        stack!.save()
        
        collectionView.reloadData()
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
        
        // New Core Data
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        stack!.save()
        
        
        
        updateBottomButton()
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
        var flickrImage = UIImage(named: "placeHolder")
        
        cell.imageView!.image = nil
        
        // Set the Flickr Image
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        
        // TODO: Add another else statement to check for cached images, similar to the
        // favorite actors app.
        
        // TODO: make url a String? instead of a String, then 
        //
        
        // Set the Photo Flickr Image
        if photo.id == nil || photo.id == "" {
            // TODO: replace with "No Image
            flickrImage = UIImage(named: "placeHolder")
        } else if photo.flickrImage != nil {
            flickrImage = photo.flickrImage
        } else {
            
            // This is the interesting case.  The photo has an flickr url, but it is not
            // downloaded yet
            
            let url = NSURL(string: photo.url)!
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error ) -> Void in
                
                if let error = error {
                    // Print out more error information than this,
                    print("Flickr download error: \(error.localizedDescription)")
                }
                
                if let data = data {
                    // Create the image
                    let image = UIImage(data: data)
            
                    // update the model, so that the image gets cached 
                    // and saved in the Documents directory.
                    
                    photo.flickrImage = image
                    
                    performUIUpdatesOnMain({ () -> Void in
                        cell.imageView.image = image
                    })
                }
            })
            task.resume()
            // cell.imageView!.image = flickrImage
        }
        cell.imageView!.image = flickrImage
        
       // If the cell is selected then it's it's color is greyed out.
        if let _ = selectedIndexes.indexOf(indexPath) {
            cell.imageView.alpha = 0.3
        } else {
            cell.imageView.alpha = 1.0
        }
        // TODO: Add code to display a placeholder image before
        // the photo is displayed.
        // See Favorite Actors (ios-persistence-2.0, step 5.3,
        // CoreDataFavoriteActors, MovieListViewController for
        // an example.
    }
    
    func updateBottomButton() {

        if selectedIndexes.count > 0 {
            removeSelectedPicturesButton.setTitle("Remove Selected Pictures", forState: .Normal)
        } else {
            removeSelectedPicturesButton.setTitle("New Collection", forState: .Normal)
        }
    }
    
}
