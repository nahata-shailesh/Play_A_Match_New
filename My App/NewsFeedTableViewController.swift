//
//  NewsFeedTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 27/06/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseDatabase

class NewsFeedTableViewController: UITableViewController {
    var about = []
    
    @IBAction func unwindToEventsPage(segue: UIStoryboardSegue) {}
    @IBAction func unwindToNewsFeed(segue: UIStoryboardSegue) {}

    @IBAction func didTapLogout(sender: UIBarButtonItem) {
        // signs the user out of the firebase app
        try! FIRAuth.auth()!.signOut()
        
        // signs the user out of the facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    let databaseRef = FIRDatabase.database().reference()
    let currentUser = FIRAuth.auth()?.currentUser
    var eventsDict = [String: AnyObject]()
    var objectArray = [[AnyObject]]()

    // Alternative to segueing directly from the storyboard
    
//    @IBAction func didTapCreateButton(sender: UIBarButtonItem) {
//        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("EventView")
//        self.presentViewController(viewController, animated: true, completion: nil)
//    
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()) {
            self.databaseRef.child("events").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                self.objectArray = []
                // todo: what if snapshot is null
                self.eventsDict = (snapshot.value as? [String : AnyObject])!
                for (key, value) in self.eventsDict {
                    let dict = value as! NSDictionary
                    self.objectArray.append([key, dict])
                }
                self.tableView.reloadData()
            })
 
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.objectArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.objectArray[indexPath.row]
        let dequeued:AnyObject = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath)
        let cell = dequeued as! UITableViewCell
        //display name of event, type, and time
        cell.textLabel?.text = data[0] as? String
        cell.detailTextLabel?.text = data[1].objectForKey("time") as? String
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let arr = self.objectArray[indexPath.row]
//        let eventDetailsTVC = EventDetailsTableViewController()
//        eventDetailsTVC.updateUI(arr)
//        //self.performSegueWithIdentifier("goToEventDetails", sender: indexPath)
//
//    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        
        if let eventDetailsTVC = destination as? EventDetailsTableViewController {
            if (segue.identifier == "goToEventDetails") {
                let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
                eventDetailsTVC.about = self.objectArray[indexPath.row]
            }
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
