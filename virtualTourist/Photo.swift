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
        static let Id = "id"
    }
    
    @NSManaged var url : String
    @NSManaged var id: String?
    @NSManaged var location: Pin?
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url = dictionary[Keys.Url] as! String
        id = dictionary[Keys.Id] as? String
    }
    
    var flickrImage: UIImage? {
        
        get {
            print(" GET flickrImage")
            return FlickrClient.Caches.imageCache.imageWithIdentifier(id)
        }
        
        set {
            print(" SET flickrImage")
            FlickrClient.Caches.imageCache.storeImage(newValue, withIdentifier: id!)
        }
    }
}
