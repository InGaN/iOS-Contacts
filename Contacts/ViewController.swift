//
//  ViewController.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 19/10/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDelegate {

    @IBOutlet weak var lbl_name: UILabel!
    var data = NSMutableData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectMe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func connectMe() {
        let url = NSURL(string: "http://api.randomuser.me/")
        
        //let json = "{ \"people\": [{ \"firstName\": \"Paul\", \"lastName\": \"Hudson\", \"isAlive\": true }, { \"firstName\": \"Angela\", \"lastName\": \"Merkel\", \"isAlive\": true }, { \"firstName\": \"George\", \"lastName\": \"Washington\", \"isAlive\": false } ] }";
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            
            if let myJson = (NSString(data: data!, encoding: NSUTF8StringEncoding))!.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: myJson)
                print(json)
            }
        }
        
        task.resume()
    }
    
    func startConnection() {
        // edit Info.plist to add exception to make a HTTP request
        let path = "http://api.randomuser.me/"
        let url: NSURL = NSURL(string: path)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                print(jsonResult)
            }
        } catch {
            print(error)
        }
    }
}

