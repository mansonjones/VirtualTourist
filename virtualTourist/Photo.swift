//
//  Photo.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// 1. Import CoreData
import CoreData

// 2. Make Photo a subclass of NSManagedObject

class Photo : NSManagedObject {
    
    struct Keys {
        static let Url = "url_m"
        static let Title = "title"
    }

    // 3. We are promoting these two simple properties to Core Data attributes
    @NSManaged var url: String
    @NSManaged var title: String
    @NSManaged var place: Location?
    
    // 4. Include this standard Core Data init method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    /**
     * 5. The two argument init method
     *
     * The Two argument Init method.  The method has two goals:
     * - insert the Photo into a Core Data Managed Object Context
     * - initialize the Photo's properties from a dictionary
     */
    
    init(dictionary: [String : AnyObject], context : NSManagedObjectContext) {

        // Get the entiry associated with the "Photo" type.  This is an object that contains
        // the information from the Model.xcdatamodeld file.  
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        // Now we can call an init method that we have inherited from NSManagedObject.  Remember that
        // the Photo class is a subclass of NSManagedObject.  This inherited init method does the work
        // of "inserting" our object into the context that was passed in as a parameter
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // After the Core Data work has been taken cre of we can init the properties from the
        // dictionary.  This works in the same way that it did before we started on Core Data
        url = dictionary[Keys.Url] as! String
        title = dictionary[Keys.Title] as! String
        
    }
    
    // TODO: This is the place where computed properties can be added.
}

