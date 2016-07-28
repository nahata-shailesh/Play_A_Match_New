//
//  EventDetailsTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 20/07/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EventDetailsTableViewController: UITableViewController {
    let currentUserId = (FIRAuth.auth()?.currentUser!.uid)!
    var eventDetails = [String:AnyObject]()
    var newArray=[String]()
    let databaseRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var chatButton: UIBarButtonItem!
    
    
 //   var fields = ["location", "age", "number", "time"]
    
//    func convert(about: NSArray) {
//        var ind = 0
//        while ind < about[1].count {
//            newArray.append(about[1][ind])
//        }
//        
//        newArray.insert(about[0])
//        print(newArray)
//        
//    }

    @IBAction func didTapChatButton(sender: UIBarButtonItem) {
        if joinButton.currentTitle == "Join Event" || joinButton.currentTitle == "This event is full" {
            let alert = UIAlertController(title: "Error",
                                          message: "Please join this event to access chat",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: .Cancel)
            { (action: UIAlertAction) -> Void in
                // do nothing
                }
            )
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func didTapJoin(sender: UIButton) {
        
        let text = joinButton.currentTitle
        var alertTitle = ""
        var alertMessage = ""
        let eventId = self.eventDetails["id"] as! String
        if text == "Join Event" {
            alertTitle = "Congratulations!"
            alertMessage = "You have joined this event"
            databaseRef.child("user_profile").child(currentUserId).child("JoinedEvents").child(eventId).setValue(eventId)
            databaseRef.child("events").child(eventId).child("Users joined").child(currentUserId).setValue(currentUserId)
            
            databaseRef.child("events").child(eventId).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                let dict = snapshot.value! as! [String:AnyObject]
                var count = dict["counter"] as! Int
                let number = dict["Number of people looking for"] as! Int
                //var number = NSNumberFormatter().numberFromString(dict["Number of people looking for"] as! String)?.integerValue
                    //NSNumberFormatter().numberFromString(dict["Number of people looking for"] as! String)?.integerValue
                
                if (count < number) {
                    count = count + 1
                    //print("Advay")
                    self.databaseRef.child("events").child(eventId).child("counter").setValue(count)
                }
                
                
                
            })
        }
        else if text == "Leave Event" {
            databaseRef.child("user_profile").child(currentUserId).child("JoinedEvents").child(eventId).removeValue()
            databaseRef.child("events").child(eventId).child("Users joined").child(currentUserId).removeValue()
            databaseRef.child("events").child(eventId).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                let dict = snapshot.value! as! [String:AnyObject]
                var count = dict["counter"] as! Int
                let number = dict["Number of people looking for"] as! Int
                //var number = NSNumberFormatter().numberFromString(dict["Number of people looking for"] as! String)?.integerValue
                
                if (count > 0) {
                    count = count - 1
                    self.databaseRef.child("events").child(eventId).child("counter").setValue(count)
                }
                
                
                
            })

            alertTitle = "Action Successful"
            alertMessage = "You have left this event"
            
            
        }
        else if text == "Delete Event" {
            let bool1 = databaseRef.child("events").child(eventId).removeValue()
            print(bool1)
            alertTitle = "Action Successful"
            alertMessage = "You have deleted this event"

        }
        else if text == "This event is full" {
            
        }
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //chatButton.enabled = false
        for(key, value) in self.eventDetails {
            if(key != "author" && key != "id" && key != "counter" && key != "Users joined") {
                if(key != "counter" && key != "Number of people looking for") {
                    let text = value as! String
                    newArray.append(key + ": "+text)
                } else {
                    let text = value as! Int
                    newArray.append(key + ": \(text)")
                }
            }
        }
        let count = eventDetails["counter"] as! Int
        let num = eventDetails["Number of people looking for"] as! Int
        let joinedUsers = eventDetails["Users joined"] as! [String: String]
        if(currentUserId == (eventDetails["author"] as! String)) {
            joinButton.setTitle("Delete Event", forState: UIControlState.Normal)
            //chatButton.enabled = true
        } else if(count < num){
            if(joinedUsers[currentUserId] == nil) {
                joinButton.setTitle("Join Event", forState: UIControlState.Normal)
            } else {
                joinButton.setTitle("Leave Event", forState: UIControlState.Normal)
                //chatButton.enabled = true
            }
        } else {
            joinButton.setTitle("This event is full.", forState: UIControlState.Normal)
        }

     
        
        dispatch_async(dispatch_get_main_queue()) {
            var index = 0
            for(key, value) in self.eventDetails {
                
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let cell: ProfileDetailsTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! ProfileDetailsTableViewCell?
                if(key != "counter" && key != "Number of people looking for") {
                    cell?.configure(key + ": "+(value as! String))
                } else {
                    cell?.configure(key + ": \(value as! Int)")
                }
                index += 1
                self.tableView.reloadData()
            }
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
        return self.newArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProfileDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath) as! ProfileDetailsTableViewCell
        cell.configure(newArray[indexPath.row])
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let chatVC = destination as? ChatViewController {
            if segue.identifier == "goToChatView" {
                chatVC.eventId = self.eventDetails["id"] as! String
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
