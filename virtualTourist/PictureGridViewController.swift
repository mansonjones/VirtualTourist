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
    
        /*
        let photo = Photo(url: "https://farm2.staticflickr.com/1696/25739821011_8cab1a1ab7.jpg", title: "airplane")
        for (var i = 0; i < 20; i++) {
            photos.append(photo)
        }
        */
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "VTCollectionViewCell"
        
        // TODO:
        
        // let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VTCollectionViewCell
        
        let url = NSURL(string: "https://farm2.staticflickr.com/1696/25739821011_8cab1a1ab7.jpg")
        
        let data = NSData(contentsOfURL: url!)
        if data != nil {
            cell.imageView.image = UIImage(data: data!)
        }
        
        // TODO
        // configureCell
 
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print(" cell selected")
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
