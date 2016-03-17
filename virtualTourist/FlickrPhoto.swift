//
//  Photo.swift
//  virtualTourist
//
//  Created by Manson Jones on 3/10/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

struct FlickrPhoto {
    let farm : Int64!
    let id : String!
    let isfamily : Int64!
    let isfriend : Int64!
    let ispublic : Int64!
    let owner: String!
    let secret : String!
    let server : String!
    let title : String!
    
    // construct a Flickr Photo from a dictionary
    init(dictionary : [String : AnyObject]) {
        farm = dictionary[FlickrClient.JSONResponseKeys.Farm] as! Int64
        id = dictionary[FlickrClient.JSONResponseKeys.Id] as! String
        isfamily = dictionary[FlickrClient.JSONResponseKeys.IsFamily] as! Int64
        isfriend = dictionary[FlickrClient.JSONResponseKeys.IsFriend] as! Int64
        ispublic = dictionary[FlickrClient.JSONResponseKeys.IsPublic] as! Int64
        owner = dictionary[FlickrClient.JSONResponseKeys.Owner] as! String
        secret = dictionary[FlickrClient.JSONResponseKeys.Secret] as! String
        server = dictionary[FlickrClient.JSONResponseKeys.Server] as! String
        title = dictionary[FlickrClient.JSONResponseKeys.Title] as! String
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
