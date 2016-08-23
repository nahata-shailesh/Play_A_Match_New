//
//  UpdateEventTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 22/08/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UpdateEventTableViewController: UITableViewController {
    
    var textfields = ["Activity Name", "Date", "Location", "Number of people looking for", "Suggested Time", "Targetted Age Group"]
    var eventID = ""
    var about = [AnyObject]()
    var ref = FIRDatabase.database().reference()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        dispatch_async(dispatch_get_main_queue()) {
            self.ref.child("events").child(self.eventID).observeEventType(.Value, withBlock: { snapshot in
                self.about = []
                for child in snapshot.children {
                    let snap = (child as? FIRDataSnapshot)!
                    if(snap.key != "Users joined" && snap.key != "author" && snap.key != "counter" && snap.key != "id") {
                        if(snap.key != "Number of people looking for") {
                            self.about.append(snap.value as! String)
                        } else {
                            self.about.append(snap.value as! Int)
                        }
                    }
                }
                self.tableView.reloadData()
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
        
    }

    @IBAction func didTapUpdateButton(sender: UIButton) {
        var index = 0
        
        while index < about.count {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell: UpdateEventTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as? UpdateEventTableViewCell
            
            if cell?.myTextField.text != "" {
                if cell?.myTextField.placeholder == "Number of people looking for" {
                    let item = NSNumberFormatter().numberFromString((cell?.myTextField.text)!)?.integerValue
                    self.ref.child("events").child(self.eventID).child("\(textfields[index])").setValue(item)
                }
                else {
                    let item: String? = cell?.myTextField.text
                    self.ref.child("events").child(self.eventID).child("\(textfields[index])").setValue(item)
                }
                
            }
            index += 1
        }
        
        let alert = UIAlertController(title: "Congratulations",
                                      message: "Your event has been updated",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: .Cancel)
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
        

        let cell: UpdateEventTableViewCell = tableView.dequeueReusableCellWithIdentifier("updateCell", forIndexPath: indexPath) as! UpdateEventTableViewCell
        
        cell.configure("\(about[indexPath.row])", placeholder: "\(textfields[indexPath.row])")
        
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
