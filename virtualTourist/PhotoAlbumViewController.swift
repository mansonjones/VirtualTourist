//
//  PictureGridViewController.swift
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
MKMapViewDelegate {
    
//    var photos = [Photo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var removeSelectedPicturesButton: UIButton!
    
    
    var location: Pin!
    let regionRadius: CLLocationDistance = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.delegate
        removeSelectedPicturesButton.enabled = false
        setupMapView()
    }
    
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
                            photo.location = self.location
                            
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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return location.photos.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "VTCollectionViewCell"
        
        // TODO:
        
        // let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        
        
        let photo = location.photos[indexPath.row]
        configureCell(cell, photo: photo)
        // cell.imageView.image = Photo.getFlickrImage(photo)!
        //cell.imageView.image = location.photos[indexPath.row].flickrImage!
      //  cell.imageView.alpha = 0.5
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(" cell selected at: ", indexPath.row)
        removeSelectedPicturesButton?.titleLabel?.text = "Remove Selected Pictures"
        let CellIdentifier = "VTCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        cell.imageView.alpha = 0.5
    }
    
    func configureCell(cell: VTCollectionViewCell, photo: Photo) {
        cell.imageView.image = Photo.getFlickrImage(photo)!
        // TODO: Add code to display a placeholder image before
        // the photo is displayed.
        // See Favorite Actors (ios-persistence-2.0, step 5.3,
        // CoreDataFavoriteActors, MovieListViewController for 
        // an example.
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
    }
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
}
