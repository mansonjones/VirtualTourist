//  Location.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/12/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import CoreData
import Foundation
import MapKit

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
