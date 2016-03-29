//
//  FlickrConvenience.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/25/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func getPhotosFromLatLonSearch(location : Pin,
        completionHandlerForLatLonSearch: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask?
    {
        
        // TODO: move the parameter value definitions into a 
        // constants file
        
        let parameters: [String : String!] = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.BoundingBox: bboxString(location),
            FlickrClient.ParameterKeys.SafeSearch: "1",
            FlickrClient.ParameterKeys.Extras: "url_m",
            FlickrClient.ParameterKeys.Format: "json",
            FlickrClient.ParameterKeys.NoJSONCallback: "1"
            /* FlickrClient.ParameterKeys.Page : "1" */
        ]
        
        let task = taskForGETMethod(FlickrClient.Methods.PhotosSearch,
            parameters: parameters) { (results, error) -> Void in
                if let error = error {
                    completionHandlerForLatLonSearch(result: nil, error: error)
                } else {
                    guard let jsonPhotoDictionary = results[FlickrClient.JSONResponseKeys.Photos] as? [String : AnyObject] else {
                        completionHandlerForLatLonSearch(result: nil, error: nil)
                        return
                    }
                   if let results = jsonPhotoDictionary[FlickrClient.JSONResponseKeys.Photo] as? [[String:AnyObject]] {
                       // let photos = Photo.photosFromResults(results)
                       completionHandlerForLatLonSearch(result: results, error: nil)
                    } else {
                        completionHandlerForLatLonSearch(result: nil, error: NSError(domain: "getPhotosFromLatLonSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotosFromLatLonSearch"]))
                    }
                }
        }
        return task
    }
    
    private func bboxString(location: Pin) -> String {
        // ensure bbox is bounded by minimum and maximums
        
        let latitude = location.latitude.doubleValue
        let longitude = location.latitude.doubleValue
        
        let minimumLon = max(longitude - FlickrClient.Constants.SearchBBoxHalfWidth,
            FlickrClient.Constants.SearchLonRange.0)
        let minimumLat = max(latitude - FlickrClient.Constants.SearchBBoxHalfHeight,
            FlickrClient.Constants.SearchLatRange.0)
        let maximumLon = min(longitude + FlickrClient.Constants.SearchBBoxHalfWidth,
            FlickrClient.Constants.SearchLonRange.1)
        let maximumLat = min(latitude + FlickrClient.Constants.SearchBBoxHalfHeight,
            FlickrClient.Constants.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }

}