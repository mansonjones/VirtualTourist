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
    @NSManaged var imageData: NSData?
    
    @NSManaged var location: Pin?
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // TODO: Declare as a convenience init.
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url = dictionary[Keys.Url] as! String
        id = dictionary[Keys.Id] as? String
        imageData = nil
    }
    
    var flickrImage: UIImage? {
        
        get {
            print(" GET flickrImage")
            // probably need an "if let" here instead of unwrapping
            // New code
            // This causes a crash
            if (imageData != nil) {
                return UIImage(data: imageData!)
            } else {
                return nil 
            }
            
            /*
            if let foo = UIImage(data: imageData!) {
                return foo
            } else {
                return nil
            }
            */
        
            // let foo: UIImage = UIImage(data: imageData!)!
            // return foo
            // old code
            // return FlickrClient.Caches.imageCache.imageWithIdentifier(id)
        }
        
        set {
            print(" SET flickrImage")
            // Given the image, set the
            // New Code
            
            if (newValue != nil) {
               self.imageData = UIImagePNGRepresentation(newValue!)
            } else {
                self.imageData = nil
            }
            
            // old code
            // FlickrClient.Caches.imageCache.storeImage(newValue, withIdentifier: id!)
        }
    }
}
