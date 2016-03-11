//
//  FlickrConvenience.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/25/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

extension FlickrClient {
    func getPhotosFromLatLonSearch(latitude : Double, longitude : Double) {
        
        let parameters = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.BoundingBox: bboxString(latitude, longitude: longitude),
            FlickrClient.ParameterKeys.SafeSearch: "1",
            FlickrClient.ParameterKeys.Extras: "extras",
            FlickrClient.ParameterKeys.Format: "json",
            FlickrClient.ParameterKeys.NoJSONCallback: "blah"
        ]
        print(parameters)
        
        taskForGETMethod(Methods.GalleriesGetPhotos, parameters: parameters) { (result, error) -> Void in
            print("getPhotosFromLatLonSearch")
        }
        
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