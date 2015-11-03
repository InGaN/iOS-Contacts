//
//  TableViewController.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 02/11/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    @IBOutlet var myTable: UITableView!
    var people = [NSManagedObject]()
    
    
    @IBAction func randomUser(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent != nil {
            // strange method to get the backbutton event, however this applies to all view for now...
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)

        let person = people[indexPath.row]
        
        cell.textLabel?.text =
            (person.valueForKey("title") as? String)! + " " +
            (person.valueForKey("first") as? String)! + " " +
            (person.valueForKey("last") as? String)!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(people[indexPath.row] as NSManagedObject)
            people.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            tableView.reloadData()
            //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            break
        default:
            return
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")        
        
        if segue.identifier == "segueTable2Person" {
            let searchIndex = self.tableView.indexPathForSelectedRow!.row
            if let destination = segue.destinationViewController as? ViewController {
                let person = people[searchIndex]
                destination.user = RandomUser(
                    gender: (person.valueForKey("gender") as? String)!,
                    title: (person.valueForKey("title") as? String)!,
                    first: (person.valueForKey("first") as? String)!,
                    last: (person.valueForKey("last") as? String)!,
                    street: (person.valueForKey("street") as? String)!,
                    city: (person.valueForKey("city") as? String)!,
                    state: (person.valueForKey("state") as? String)!,
                    zip: (person.valueForKey("zip") as? String)!,
                    email: (person.valueForKey("email") as? String)!,
                    username: (person.valueForKey("username") as? String)!,
                    password: (person.valueForKey("password") as? String)!,
                    salt: (person.valueForKey("salt") as? String)!,
                    md5: (person.valueForKey("md5") as? String)!,
                    sha1: (person.valueForKey("sha1") as? String)!,
                    sha256: (person.valueForKey("sha256") as? String)!,
                    dob: (person.valueForKey("dob") as? String)!,
                    phone: (person.valueForKey("phone") as? String)!,
                    cell: (person.valueForKey("cell") as? String)!,
                    image: (person.valueForKey("image") as? String)!,
                    thumb: (person.valueForKey("thumb") as? String)!,
                    nationality: (person.valueForKey("nationality") as? String)!)
            }
        }
        
        else if segue.identifier == "segueRandom2Person" {
            if let destination = segue.destinationViewController as? ViewController {
                destination.random = true;
            }
        }
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
