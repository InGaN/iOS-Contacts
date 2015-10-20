//
//  ViewController.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 19/10/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data = NSMutableData()
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_email: UIButton!
    @IBOutlet weak var img_portrait: UIImageView!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_state_city: UILabel!
    @IBOutlet weak var lbl_street: UILabel!
    @IBOutlet weak var lbl_bsn: UILabel!
    
    @IBOutlet weak var btn_newPerson: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectMe()
    }
    
    @IBAction func btn_newPerson_Pressed(sender: AnyObject) {
        connectMe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func connectMe() {
        let url = NSURL(string: "http://api.randomuser.me/")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
            
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if let myJson = (NSString(data: data!, encoding: NSUTF8StringEncoding))!.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: myJson)
                print(json)
                
                if let arr = json["results"].array {
                    let fir = arr[0]["user"]["dob"]
                    print(fir.stringValue)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var output = (arr[0]["user"]["name"]["title"].stringValue) + " "
                        output += (arr[0]["user"]["name"]["first"].stringValue) + " "
                        output += (arr[0]["user"]["name"]["last"].stringValue) + " ("
                        output += (arr[0]["user"]["gender"].stringValue) + ")"
                        self.lbl_name.text = output
                        
                        output = (arr[0]["user"]["email"].stringValue)
                        self.btn_email.setTitle(output, forState: .Normal)
                        
                        let url = NSURL(string: (arr[0]["user"]["picture"]["medium"].stringValue))
                        self.downloadImage(url!)
                        
                        if let flag = json["nationality"].string {
                            if (UIImage(named: flag) == nil) {
                                self.img_flag.image = UIImage(named: "unknown_flag")
                            }
                            else {
                                self.img_flag.image = UIImage(named: flag)
                            }
                        }
                        output = (arr[0]["user"]["location"]["street"].stringValue)
                        self.lbl_street.text = output
                        
                        output = (arr[0]["user"]["location"]["state"].stringValue) + ", " + (arr[0]["user"]["location"]["city"].stringValue)
                        self.lbl_state_city.text = output
                        
                        output = (arr[0]["user"]["phone"].stringValue)
                        self.lbl_bsn.text = "Tel: " + output
                    })
                }
            }
        }
        task.resume()
    }

    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
    
    func downloadImage(url:NSURL){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.img_portrait.image = UIImage(data: data!)
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("Landscape")
            // need to change views on orientation once I found out how that works flawlessly....
        }
        else {
            print("Portrait")
        }
    }
}

