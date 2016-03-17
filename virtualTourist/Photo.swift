//
//  Photo.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// 1. Import CoreData
import CoreData
import UIKit

// 2. Make Photo a subclass of NSManagedObject


class Photo {
    
    // Note : there are many other key-value pairs
    // returned by flickr, but url_m is the only
    // one we need for now.
    // Maybe add title once it's all working.
    
    // TODO: Move this to the constants file.
    
    struct Keys {
        static let Url = "url_m"
    }
    
    var url : String
    var title : String
    
    init(url: String, title: String) {
        self.url = url
        self.title = title
    }
    
    init(dictionary: [String : AnyObject]) {
        url = dictionary[Keys.Url] as! String
        title = "TITLE"
    }
    
    // TODO: add a computed parameter to return the URL
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

/*
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
*/
