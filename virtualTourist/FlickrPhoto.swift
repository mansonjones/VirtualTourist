//
//  Photo.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/10/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

struct FlickrPhoto {
    let url: String
    
    // construct a Flickr Photo from a dictionary
    init(dictionary : [String : AnyObject]) {
        url = dictionary[FlickrClient.JSONResponseKeys.Url] as! String
    }
    
    static func photosFromResults(results: [[String : AnyObject]]) -> [FlickrPhoto] {
        var photos = [FlickrPhoto]()
        
        // iterate through array of dictionaries, each Photo is a dictionary
        for result in results {
            photos.append(FlickrPhoto(dictionary: result))
        }
        
        return photos
    }
}
