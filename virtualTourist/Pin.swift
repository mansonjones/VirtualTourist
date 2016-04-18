//  Location.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import CoreData
import Foundation

class Pin : NSManagedObject {
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var hashNumber: NSNumber
    @NSManaged var photos: [Photo]
    
    // Standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(pinLatitude: Double, pinLongitude: Double, pinHashNumber: Int, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        latitude = NSNumber(double: pinLatitude)
        longitude = NSNumber(double: pinLongitude)
        hashNumber = pinHashNumber
    }
}

