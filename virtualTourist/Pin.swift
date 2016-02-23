//
//  Pin.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// This is modeled on Person.swift from the Favorite Actors App
// The Virtual Tourist App has an array of pin objects

import CoreData
import UIKit

class Pin : NSManagedObject {
    // TODO: define the pint properties
    struct Keys {
        static let Location = "location"
    }
    
    @NSManaged var location: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        location = dictionary[Keys.Location] as! String
        
    }
 
    /*
      Need something similar to this to return the pin
    var image: UIImage? {
        get {
            return TheMovieB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        set {
             TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath)
        }
    }
    */
}
