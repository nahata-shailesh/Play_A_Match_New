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
        self.hideKeyboardWhenTappedAround()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        self.ref.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        
        let usersDict = snapshot.value as! NSDictionary
        let userDetails = usersDict.objectForKey(self.user!.uid)
        
        var index = 0
        while index < self.about.count {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell: TextInputTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableViewCell?
            let field: String? = (cell?.TextField.placeholder)!
            if field == "Name" && userDetails!["Name"] != nil  {
                cell?.configure("", placeholder: self.user?.displayName)
                cell?.userInteractionEnabled = false
                cell?.textLabel!.enabled = false
                cell?.TextField.attributedPlaceholder = NSAttributedString(string: (self.user?.displayName)!,
                    attributes:[NSForegroundColorAttributeName: UIColor.blueColor()])
            }
            else if field == "Email" && userDetails!["Email"] != nil {
                cell?.configure("", placeholder: self.user?.email)
                cell?.userInteractionEnabled = false
                cell?.textLabel!.enabled = false
                cell?.TextField.attributedPlaceholder = NSAttributedString(string: (self.user?.email)!,
                    attributes:[NSForegroundColorAttributeName: UIColor.blueColor()])
            } else {
                cell?.configure(userDetails?.objectForKey(field!) as? String, placeholder: field!)
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
                self.ref.child("user_profile").child("\(user!.uid)/\(about[index])").setValue(item)
                
            }
            index += 1
        }
        
        let alert = UIAlertController(title: "Congratulations",
                                      message: "Your details have been updated",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: .Cancel)
        { (action: UIAlertAction) -> Void in
            // do nothing
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)

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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
