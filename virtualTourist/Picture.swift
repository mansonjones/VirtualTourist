//
//  Picture.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// This is modeled on the Movie.swift file from the 
// Favorite Actors App
// Each Pin will have an array of Picture objects

import UIKit
import CoreData

class Picture : NSManagedObject {
    
    struct Keys {
        static let Picture = "picture"
    }
    @NSManaged var picture: String
    // @NSManaged var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity = NSEntityDescription.entityForName("Picture", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        picture = dictionary["foo"] as! String
        
    }
    
    var pictureImage: UIImage? {
        
        get {
            // Could add an image asset and then
            // load a real image here.  Could be useful for testing
            return UIImage()
        }
        
        set {
            
        }
    }
}
