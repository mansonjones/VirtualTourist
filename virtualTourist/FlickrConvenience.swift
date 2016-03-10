//
//  FlickrConvenience.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/25/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

func getPhotosFromLocation(latitude : Double, longitude : Double) {
    let methodParameters = [
        FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
        FlickrClient.ParameterKeys.APIKey: FlickrClient.ParameterValues.APIKey,
        FlickrClient.ParameterKeys.BoundingBox: "",
        FlickrClient.ParameterKeys.SafeSearch: "",
        FlickrClient.ParameterKeys.Extras: "",
        FlickrClient.ParameterKeys.Format: "",
        FlickrClient.ParameterKeys.NoJSONCallback: ""
    ]
    print(methodParameters)
}