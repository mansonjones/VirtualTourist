//
//  Photo.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import CoreData
import UIKit

// This is the Core Data version

class Photo : NSManagedObject {
    
    struct Keys {
        static let Url = "url_m"
    }
    
    @NSManaged var url : String
    @NSManaged var location: Pin?
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url = dictionary[Keys.Url] as! String
    }
    
    static func getFlickrImage(myPhoto : Photo) -> UIImage? {
        let url = myPhoto.url
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        if data != nil {
            return UIImage(data: data!)
        }
        return nil
    }
    
    var flickrImage : UIImage? {
        get {
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            if data != nil {
                return UIImage(data: data!)
            }
            return nil
        }
    }
    
}

// The earlier version, before Core Data was implemented.

/*
class Photo {
    struct Keys {
        static let Url = "url_m"
    }
    
    var url : String
    
    init(dictionary: [String : AnyObject]) {
        url = dictionary[Keys.Url] as! String
    }
    
    // Using this function instead of the computed property to 
    // avoid problems with core data
    
    static func getFlickrImage(myPhoto : Photo) -> UIImage? {
        let url = myPhoto.url
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        if data != nil {
            return UIImage(data: data!)
        }
        return nil
    }
    
    // TODO: Figure out how to get this computed property to work
    // with core data.
    
    var flickrImage : UIImage? {
        get {
            // let testUrl = NSURL(string: "https://farm2.staticflickr.com/1696/25739821011_8cab1a1ab7.jpg")!
            
            
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            if data != nil {
                return UIImage(data: data!)
            }
            return nil
        }
    }
    
    static func photosFromResults(results: [[String:AnyObject]]) -> [Photo] {
        
        var photos = [Photo]()
        
        // iterate through the array of dictionaries, each Photo is a dictionary
        for result in results {
            photos.append(Photo(dictionary: result))
        }
        
        return photos
    }
}
*/
