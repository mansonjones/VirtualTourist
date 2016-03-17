//
//  FlickrConvenience.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/25/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func getPhotosFromLatLonSearch(latitude : Double, longitude : Double,
        completionHandlerForLatLonSearch: (result: [Photo]?, error: NSError?) -> Void) -> NSURLSessionDataTask?
    {
        
        // TODO: move the parameter value definitions into a 
        // constants file
        
        let parameters: [String : String!] = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.BoundingBox: bboxString(latitude, longitude: longitude),
            FlickrClient.ParameterKeys.SafeSearch: "1",
            FlickrClient.ParameterKeys.Extras: "url_m",
            FlickrClient.ParameterKeys.Format: "json",
            FlickrClient.ParameterKeys.NoJSONCallback: "1"
            /* FlickrClient.ParameterKeys.Page : "1" */
        ]
        
        print(parameters)
        
        let task = taskForGETMethod(FlickrClient.Methods.PhotosSearch,
            parameters: parameters) { (results, error) -> Void in
                print("getPhotosFromLatLonSearch")
                if let error = error {
                    completionHandlerForLatLonSearch(result: nil, error: error)
                } else {
                    print(" ****************** Start Raw *******************")
                   // print(results)
                    print(" ****************** End Raw *********************")
                    guard let jsonPhotoDictionary = results[FlickrClient.JSONResponseKeys.Photos] as? [String : AnyObject] else {
                        completionHandlerForLatLonSearch(result: nil, error: nil)
                        return
                    }
                    print(" ****************** Start Dict *******************")
                    print(jsonPhotoDictionary)
                    print(" ****************** End Dict *********************")
                    
                    if let results = jsonPhotoDictionary[FlickrClient.JSONResponseKeys.Photo] as? [[String:AnyObject]] {
                        let photos = Photo.photosFromResults(results)
                        print(" **** Start photos ***")
                        print(photos)
                        print(" **** End photos ***")
                        
                        completionHandlerForLatLonSearch(result: photos, error: nil)
                    } else {
                        completionHandlerForLatLonSearch(result: nil, error: NSError(domain: "getPhotosFromLatLonSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotosFromLatLonSearch"]))
                    }
                }
        }
        return task
    }
    
    private func bboxString(latitude: Double, longitude: Double) -> String {
        // ensure bbox is bounded by minimum and maximums
        
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