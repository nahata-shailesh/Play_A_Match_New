//
//  UserDetailsTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 21/08/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserDetailsTableViewController: UITableViewController {
    var userID = ""
    var eventID = ""
    var about = [String]()
    let databaseRef = FIRDatabase.database().reference()
    let currentUserId = (FIRAuth.auth()?.currentUser!.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.title = "Users Details" 
        dispatch_async(dispatch_get_main_queue()) {
            self.databaseRef.child("user_profile").child(self.userID).observeEventType(.Value, withBlock: { snapshot in
                self.about = []
                for child in snapshot.children {
                    let snap = (child as? FIRDataSnapshot)!
                    if(snap.key != "JoinedEvents" && snap.key != "MyEvents") {
                        self.about.append(snap.key+": "+(snap.value as! String))
                    }
                }
                self.tableView.reloadData()
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
        
    }

    @IBAction func didPressRemoveUserButton(sender: UIButton) {
        databaseRef.child("events").child(self.eventID).child("Users joined").child(userID).removeValue()
    databaseRef.child("user_profile").child(userID).child("JoinedEvents").child(self.eventID).removeValue()
        
        //add alert and redirect back to manage events
        var alert = UIAlertController(title: "Action Successful",
                                      message: "You have successfully removed this user!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
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
        let cell: UserDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("User Field", forIndexPath: indexPath) as! UserDetailTableViewCell
        
        cell.configure(about[indexPath.row])
        
        return cell
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
