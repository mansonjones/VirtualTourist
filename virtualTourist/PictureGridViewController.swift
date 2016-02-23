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

class PictureGridViewController: UIViewController
/*, UICollectionViewDataSource, UICollectionViewDelegate */ {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(animated: Bool) {
        
        /*
         if pin.pictures.isEmpty {
            let resource =
            let parameters =
            Flickr.sharedInstance().taskForResource(resource, parameters: parameters) { JSONResult, error in
                if let error = error {
                    print(error)
                } else {
                    ....
                }
         */
        
        // Note: Instead of 
        // movie.actor we'll have
        // picture.pin
        // Instead of 
        // movie.actor = nil
        // We'll
    }
    
    /*
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "PictureCell"
        
        // TODO:
        
        // let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! Picture
        
        // TODO
        // configureCell
 
        return cell
    }
    */
    
    /*
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        // TODO: Add code for insert and delete
    }
    
    */
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
