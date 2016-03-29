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
    
    init(dictionary: [String : AnyObject]) {
        url = dictionary[Keys.Url] as! String
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
