//
//  ManageEventTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 21/08/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ManageEventTableViewController: UITableViewController {
    var about = [String]()
    var ids = [String]()
    var eventID = ""
    let databaseRef = FIRDatabase.database().reference()
    let currentUserId = (FIRAuth.auth()?.currentUser!.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users Joined" 
        dispatch_async(dispatch_get_main_queue()) {
            self.databaseRef.child("events").child(self.eventID).child("Users joined").observeEventType(.Value, withBlock: { snapshot in
                self.about = []
                for child in snapshot.children {
                    let snap = (child as? FIRDataSnapshot)!
                    if(snap.key != self.currentUserId) {
                        self.ids.append(snap.key)
                        self.about.append(snap.value as! String)
                    }

                }
                self.tableView.reloadData()
                }, withCancelBlock: { error in
                    print(error.description)
            })
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
        return self.about.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("User Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = about[indexPath.row]
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        if let userDetailVC = destination as? UserDetailsTableViewController {
            if segue.identifier == "goToUserDetails" {
                let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
                userDetailVC.userID = self.ids[indexPath.row]
                userDetailVC.eventID = self.eventID
            }
        }
        
        if let updateEventsVC = destination as? UpdateEventTableViewController {
            if segue.identifier == "goToUpdateEvent" {
                updateEventsVC.eventID = eventID
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
