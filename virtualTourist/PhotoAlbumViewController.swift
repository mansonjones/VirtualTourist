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
    
    var photos = [Photo]()
    
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
        
        FlickrClient.sharedInstance().getPhotosFromLatLonSearch(location)
            { (photos, error) -> Void in
                if let photos = photos {
                    self.photos = photos
                    performUIUpdatesOnMain {
                        self.collectionView.reloadData()
                        // TODO : enable
                       self.removeSelectedPicturesButton.enabled = true
                    }
                } else {
                    print("Download of Flickr Photo failed")
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
        return photos.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "VTCollectionViewCell"
        
        // TODO:
        
        // let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        
        cell.imageView.image = photos[indexPath.row].flickrImage!
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
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
