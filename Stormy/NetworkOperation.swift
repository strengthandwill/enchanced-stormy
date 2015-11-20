//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Poh Kah Kong on 10/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import Foundation

class NetworkOperation {
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                        completion(jsonDictionary)
                    } catch {
                        print("json error: \(error)")
                    }
                default:
                    print("The request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }            
        }
        dataTask.resume()
    }

}