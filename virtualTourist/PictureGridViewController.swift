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

class PictureGridViewController: UIViewController,
UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photos = [Photo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var removeSelectedPicturesButton: UIButton!
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.delegate = self
        print("latitude, longitude", self.latitude!, self.longitude!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        FlickrClient.sharedInstance().getPhotosFromLatLonSearch(latitude!, longitude: longitude!)
            { (photos, error) -> Void in
                if let photos = photos {
                    self.photos = photos
                    performUIUpdatesOnMain {
                        self.collectionView.reloadData()
                    }
                } else {
                    print("Download of Flickr Photo failed")
                }
        }

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
 
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print(" cell selected at: ", indexPath.row)
        removeSelectedPicturesButton?.titleLabel?.text = "Remove Selected Pictures"
    }
    
    
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
