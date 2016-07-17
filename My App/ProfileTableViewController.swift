//
//  ProfileTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 16/07/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileTableViewController: UITableViewController {
    
    var about = ["Name", "Gender", "Age", "Phone", "Email"]
    
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        var refHandle = self.ref.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let usersDict = snapshot.value as! NSDictionary
            let userDetails = usersDict.objectForKey(self.user!.uid)
            
            var index = 0
            
            while index < self.about.count {
                
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let cell: TextInputTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableViewCell?
                let field: String? = (cell?.TextField.placeholder)!
                
                switch field! {
                case "Name" :
                    cell?.configure(userDetails?.objectForKey("Name") as? String, placeholder: "Name")
                case "Phone" :
                    cell?.configure(userDetails?.objectForKey("Phone") as? String, placeholder: "Phone")
                case "Gender" :
                    cell?.configure(userDetails?.objectForKey("Gender") as? String, placeholder: "Gender")
                case "Age" :
                    cell?.configure(userDetails?.objectForKey("Age") as? String, placeholder: "Age")
                case "Email" :
                    cell?.configure(userDetails?.objectForKey("Email") as? String, placeholder: "Email")
                default:
                    break
                    
                }
                index += 1
            }
            
        })
    }
    
    @IBAction func didTapUpdate(sender: UIButton) {
        
        var index = 0
        
        while index < about.count {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell: TextInputTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as? TextInputTableViewCell
            
            if cell?.TextField.text != "" {
                let item: String? = cell?.TextField.text
                
                switch about[index] {
                case "Name":
                    self.ref.child("user_profile").child("\(user!.uid)/Name").setValue(item)
                case "Phone":
                    self.ref.child("user_profile").child("\(user!.uid)/Phone").setValue(item)
                    case "Gender":
                        self.ref.child("user_profile").child("\(user!.uid)/Gender").setValue(item)
                    case "Age":
                        self.ref.child("user_profile").child("\(user!.uid)/Age").setValue(item)
                    case "Email":
                        self.ref.child("user_profile").child("\(user!.uid)/Email").setValue(item)
                default:
                    print ("Dont update!")
                }
            }
            index += 1
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
        return about.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TextInputTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextInputCell", forIndexPath: indexPath) as! TextInputTableViewCell

         cell.configure("", placeholder: "\(about[indexPath.row])")

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
