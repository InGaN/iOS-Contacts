//
//  ViewController.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 19/10/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var data = NSMutableData()
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_email: UIButton!
    @IBOutlet weak var img_portrait: UIImageView!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_state_city: UILabel!
    @IBOutlet weak var lbl_street: UILabel!
    @IBOutlet weak var lbl_bsn: UILabel!
    @IBOutlet weak var lbl_countryCode: UILabel!
    
    @IBOutlet weak var btn_newPerson: UIButton!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTopLeft: UIView!
    @IBOutlet weak var viewTopRight: UIView!
    
    var user: RandomUser!
    
    var random: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(random) {
            connectMe()
        }
        else if (user != nil){
            fillLabels(user)
        }
    }    
    
    @IBAction func randomUser(sender: AnyObject) {
        connectMe()
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext        
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(user.gender, forKey: "gender")
        person.setValue(user.title, forKey: "title")
        person.setValue(user.first, forKey: "first")
        person.setValue(user.last, forKey: "last")
        person.setValue(user.street, forKey: "street")
        person.setValue(user.city, forKey: "city")
        person.setValue(user.state, forKey: "state")
        person.setValue(user.zip, forKey: "zip")
        person.setValue(user.email, forKey: "email")
        person.setValue(user.username, forKey: "username")
        person.setValue(user.password, forKey: "password")
        person.setValue(user.salt, forKey: "salt")
        person.setValue(user.md5, forKey: "md5")
        person.setValue(user.sha1, forKey: "sha1")
        person.setValue(user.sha256, forKey: "sha256")
        person.setValue(user.dob, forKey: "dob")
        person.setValue(user.phone, forKey: "phone")
        person.setValue(user.cell, forKey: "cell")
        person.setValue(user.image, forKey: "image")
        person.setValue(user.thumb, forKey: "thumb")
        person.setValue(user.nationality, forKey: "nationality")
        
        do {
            try managedContext.save()
            //people.append(person)
        } catch let error as NSError {
            print("unable to save \(error), \(error.userInfo)")
        }
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
                
                self.createPerson(json)
                
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
                            self.lbl_countryCode.text = flag
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
    
    func fillLabels(user:RandomUser) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var output = user.title! + " "
            output += user.first! + " "
            output += user.last! + " ("
            output += user.gender! + ")"
            self.lbl_name.text = output
            
            output = user.email!
            self.btn_email.setTitle(output, forState: .Normal)
            
            let url = NSURL(string: user.image!)
            self.downloadImage(url!)
            
            if let flag = user.nationality {
                self.lbl_countryCode.text = flag
                if (UIImage(named: flag) == nil) {
                    self.img_flag.image = UIImage(named: "unknown_flag")
                }
                else {
                    self.img_flag.image = UIImage(named: flag)
                }
            }
            output = user.street!
            self.lbl_street.text = output
            
            output = user.state! + ", " + user.city!
            self.lbl_state_city.text = output
            
            output = user.phone!
            self.lbl_bsn.text = "Tel: " + output
        })
    }
    
    func createPerson(json:JSON) {
        print(json)
        if let arr = json["results"].array {
            self.user = RandomUser(
                gender: arr[0]["user"]["gender"].stringValue,
                title: arr[0]["user"]["name"]["title"].stringValue,
                first: arr[0]["user"]["name"]["first"].stringValue,
                last: arr[0]["user"]["name"]["last"].stringValue,
                street: arr[0]["user"]["location"]["street"].stringValue,
                city: arr[0]["user"]["location"]["city"].stringValue,
                state: arr[0]["user"]["location"]["state"].stringValue,
                zip: arr[0]["user"]["location"]["zip"].stringValue,
                email: arr[0]["user"]["email"].stringValue,
                username: arr[0]["user"]["username"].stringValue,
                password: arr[0]["user"]["password"].stringValue,
                salt: arr[0]["user"]["salt"].stringValue,
                md5: arr[0]["user"]["md5"].stringValue,
                sha1: arr[0]["user"]["sha1"].stringValue,
                sha256: arr[0]["user"]["sha256"].stringValue,
                dob: arr[0]["user"]["dob"].stringValue,
                phone: arr[0]["user"]["phone"].stringValue,
                cell: arr[0]["user"]["cell"].stringValue,
                image: arr[0]["user"]["picture"]["medium"].stringValue,
                thumb: arr[0]["user"]["picture"]["thumbnail"].stringValue,
                nationality: json["nationality"].stringValue)
        }
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

