//
//  Flickr.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// This is equivalent to TheMovieDB.swift

import Foundation

// MARK: - FlickClient: NSObject

class FlickrClient : NSObject {
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // configuration object
    // TODO: 
    // var config = FlickrConfig()
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, var parameters: [String:AnyObject],
        completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        parameters["a" /* ParameterKeys.ApiKey */] = "b" /* Constants.ApiKey */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: flickrURLFromParameters(parameters))
        
        /* 4. Make the request */
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                func sendError(error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForGET(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                }
        
        /* Guard: Was there an error? */
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error)")
                    return
                }
        
        /* Guard Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 &&
            statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
                }
                /* Guard: Was there any data returned? */
                /* TODO: fix the warning from the next block
                guard let data = data else {
                    sendError("No data was returned by the request!")
                    return
                }
                */
            }
                /* 7. Start the request */
            task.resume()
            return task
    }
    
    // Create a URL from parameters
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = FlickrClient.Constants.ApiScheme
        components.host = FlickrClient.Constants.ApiHost
        components.path = FlickrClient.Constants.ApiPath
        
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }

}
