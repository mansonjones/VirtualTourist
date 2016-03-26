//  Location.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation
import MapKit

// 1. Import CoreData
import CoreData

class Pin {
    var latitude: NSNumber
    var longitude: NSNumber
    
    init(latitude: Double, longitude: Double) {
        self.latitude = NSNumber(double: latitude)
        self.longitude = NSNumber(double: longitude)
    }
    
    var pin: MKPointAnnotation? {
        get {
            let annotation = MKPointAnnotation()
            let lat = CLLocationDegrees(latitude.doubleValue)
            let lon = CLLocationDegrees(longitude.doubleValue)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.title = "title"
            annotation.subtitle = "sub-title"
            return annotation
        }
    }
    
}
// 2. Make Location a subclass of NSManagedObject
/*
class Pin : NSManagedObject {

struct Keys {
static let Latitude = "latitude"
static let Longitude = "longitude"
static let Name = "name"
}

// 3. We are promoting these four from simple properties, to Core Data attributes
@NSManaged var latitude: Double
@NSManaged var longitude: Double
@NSManaged var name: String?
@NSManaged var photos: [Photo]

// 4. Include this standard Core Data init method.
override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
super.init(entity: entity, insertIntoManagedObjectContext: context)
}

/**
* 5. The two argument init method
*
* The Two arguemtn Init method.  The method has two goals:
* - insert the new Pin into a Core Data Managed Object Context
* - initialize the Person's properties from a dictionary
*/

init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
// Get the entify associated with the "Location" type.  This is an object that contains
// the information from the Model.xcdatamodeld file.  We will talk about this file in
// Lesson 4.
let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)!

// Now we can call an init method that we have inherited from NSManagedObject.  Remember that
// the Location class is a subclass of NSManagedObject.  This inherited init method does the
// work of "inserting" our object into the context that was passed in as a parameter
super.init(entity: entity, insertIntoManagedObjectContext: context)

// After the Core Data work has been taken care of we can init the properties from the
// dictionary.  This works in the same way that id did before we started on Core Data
latitude = dictionary[Keys.Latitude] as! Double
longitude = dictionary[Keys.Longitude] as! Double
name = dictionary[Keys.Name] as? String

}

TODO: Define the MKAnnotation (or maybe call it a pin) as a
var annotation: MKAnnotation? {
get {
return
}
set {

}
}

}

*/
