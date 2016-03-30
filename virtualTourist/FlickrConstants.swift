//
//  Flickr-Constants.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// Equivalent to file TheMovieDB-Constants.swift


extension FlickrClient {
    
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct Methods {
        // MARK: galleries.getPhoto
        // TODO: complete this section
        static let GalleriesGetPhotos = "flickr.galleries.getPhotos"
        static let PhotosSearch = "flickr.photos.search"
    }
    
    //
    struct ParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let SafeSearch = "safe_search"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let BoundingBox = "bbox"
        static let Page = "page"       // This is required 
        static let PerPage = "per_page"
    }
    

    // MARK: Flick Parameter Values

    struct ParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "167e6d205a8f3675b36eedb81c76e447"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryID = "5704-72157622566655097" // sleeping in the library
        static let MediumURL = "url_m"
        static let DataFormat = "json"
        static let NoJSONCallBack = "1"
    }
    
    // MARK: Flickr Response Keys
    struct JSONResponseKeys {
        static let Url = "url"
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        
        static let MediumURL = "url_m"
        static let Farm = "farm"
        static let Id = "id"
        static let IsFamily = "isfamily"
        static let IsFriend = "isfriend"
        static let IsPublic = "ispublic"
        static let Owner = "owner"
        static let Secret = "secret"
        static let Server = "server"
        static let Title = "title"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    
}