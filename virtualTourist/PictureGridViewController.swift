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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        FlickrClient.sharedInstance().getPhotosFromLatLonSearch(34.0481, longitude: -118.5256)
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
    }
    
    
    /*
    lazy var scratchContext: NSManagedObjectContext {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }
    */
    
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
