//
//  Config.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/21/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation
import MapKit

/*
  The config struct stores information that is used to build
  the map region
*/

// MARK: - Files Support
private let _documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
private let _fileURL: NSURL = _documentsDirectoryURL.URLByAppendingPathComponent("VirtualTourist-Context")


class Config: NSObject, NSCoding {
    
    var centerLatitude: Double = 0.0
    var centerLongitude: Double = 0.0
    var regionWidth: Double = 1.0
    var regionHeight: Double = 1.0
    
    // Would this work?
    // var mapRegion : MKCoordinateRegion?
    override init() {
        
    }
    
    
    
    init(centerLatitude: Double, centerLongitude: Double, width: Double, height: Double) {
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
        self.regionWidth = width
        self.regionHeight = height
    }
    
    // Returns the number days since the config was last updated.
    /*
    var mapRegion: MKCoordinateRegion? {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
    
    */
   
    // MARK: - NSCoding
    
    let CenterLatitude = "CenterLatitude"
    let CenterLongitude =  "CenterLongitude"
    let LatitudinalMeters = "LatitudinalMeters"
    let LongitudinalMeters = "LongitudinalMeters"
    
    required init?(coder aDecoder: NSCoder) {
        centerLatitude = aDecoder.decodeDoubleForKey(CenterLatitude) 
        centerLongitude = aDecoder.decodeDoubleForKey(CenterLongitude) 
        regionWidth = aDecoder.decodeDoubleForKey(LatitudinalMeters) 
        regionHeight = aDecoder.decodeDoubleForKey(LongitudinalMeters) 
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(centerLatitude, forKey: CenterLatitude)
        aCoder.encodeDouble(centerLongitude, forKey: CenterLongitude)
        aCoder.encodeDouble(regionWidth, forKey: LatitudinalMeters)
        aCoder.encodeDouble(regionHeight, forKey: LongitudinalMeters)
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: _fileURL.path!)
    }
    
    class func unarchivedInstance() -> Config? {
        
        if NSFileManager.defaultManager().fileExistsAtPath(_fileURL.path!) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(_fileURL.path!) as? Config
        } else {
            return nil
        }
        // Would this work?
        /*
        if let region = NSKeyedArchiver.unarchiveObjectWithFile(filePath) as? MKCoordinateRegion {
          newRegion = region
        
        */
    }
}














