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
        completionHandlerForLatLonSearch: (result: [FlickrPhoto]?, error: NSError?) -> Void) -> NSURLSessionDataTask?
    {
        let parameters: [String : String!] = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.BoundingBox: bboxString(latitude, longitude: longitude),
            FlickrClient.ParameterKeys.SafeSearch: "1",
            FlickrClient.ParameterKeys.Extras: "url_m:",
            FlickrClient.ParameterKeys.Format: "json",
            FlickrClient.ParameterKeys.NoJSONCallback: "1"
        ]
        
        print(parameters)
        
        let task = taskForGETMethod(FlickrClient.Methods.PhotosSearch,
            parameters: parameters) { (results, error) -> Void in
            print("getPhotosFromLatLonSearch")
                if let error = error {
                    completionHandlerForLatLonSearch(result: nil, error: error)
                } else {
                  //  print("Here is the raw result")
                    // print("\(results)")
                    guard let foo = results[FlickrClient.JSONResponseKeys.Photos] as? [String : AnyObject] else {
                        completionHandlerForLatLonSearch(result: nil, error: nil)
                        return
                    }
                    // print(" *** FOO ***")
                    // print(foo)
                    // print(" *** END OF FOO ***")
                    guard let bar = foo[FlickrClient.JSONResponseKeys.Photo] as? [[String: AnyObject]] else {
                        completionHandlerForLatLonSearch(result: nil, error: nil)
                        return
                    }
                    // At this point we have an array of dictionaries, where
                    // each element in the arrar represents a FlickrPhoto
                    print("\(bar)")
                    print("The number of elements in bar is:", bar.count)
                    
                    print("the First element of the array is")
                    print("\(bar[0])")
                   // let photos = FlickrPhoto.photosFromResults(bar)
                    // completionHandlerForLatLonSearch(result: photos, error: nil)
                    
                    // let photos = FlickrPhoto.photosFromResults(bar)
                    // completionHandlerForLatLonSearch(result: photos, error: nil)
                    
                    
                    // print(" Number of photos  ***")
                    // print(photos.count)
                    
                    if (error != nil) {
                       completionHandlerForLatLonSearch(result: nil, error: nil)
                    
                    /*
                    if let results = results[FlickrClient.JSONResponseKeys.Photos] as? [[String : AnyObject]] {
                        completionHandlerForLatLonSearch(result: nil, error: nil)
                    
                        if let results = results[FlickrClient.JSONResponseKeys.Photo] as? [[String :AnyObject]] {
                            let photos = FlickrPhoto.photosFromResults(stuff)
                            completionHandlerForLatLonSearch(result: photos, error: nil)
                        }
                        */
                    } else {
                        completionHandlerForLatLonSearch(result: nil,
                            error: NSError(domain: "getPhotosFromLatLonSearch parsing", code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotosFromLatLonSearch"]))
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