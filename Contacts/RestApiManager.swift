//
//  RestApiManager.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 19/10/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit
typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    let url = "http://api.randomuser.me/"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = url
        makeHTTPGetRequest(route, onCompletion: { json, err in onCompletion(json as JSON)})
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        
        task.resume()
    }
}
