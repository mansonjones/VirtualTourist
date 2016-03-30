//  Location.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import CoreData
import Foundation
import MapKit


// This version works with Core Data

/*
class Pin : NSManagedObject {
    
    struct Keys {
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var photos: [Photo]
    
    // Standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {

        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        self.latitude = dictionary[Keys.Latitude] as! Double
        self.longitude = dictionary[Keys.Longitude] as! Double
    }
    
    var pin: MKPointAnnotation? {
        get {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(latitude.doubleValue),
                longitude: CLLocationDegrees(longitude.doubleValue)
            )
            return annotation
        }
    }
    
}
*/
// Earlier Version, before Core Data

class Pin {
    
    struct Keys {
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    var latitude: NSNumber
    var longitude: NSNumber
    var photos: [Photo] = [Photo]()
    
    init(dictionary: [String : AnyObject]) {
        self.latitude = dictionary[Keys.Latitude] as! Double
        self.longitude = dictionary[Keys.Longitude] as! Double
    }
    
    
    static func getMKPointAnnotiation(myPin : Pin) -> MKPointAnnotation? {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: myPin.latitude.doubleValue,
            longitude: myPin.longitude.doubleValue
        )
        return annotation
    }
    
    // TODO: Figure out how to use this computed
    // property with Core Data
    var pin: MKPointAnnotation? {
        get {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(latitude.doubleValue),
                longitude: CLLocationDegrees(longitude.doubleValue)
            )
            return annotation
        }
    }
    
}

