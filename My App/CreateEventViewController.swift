//
//  CreateEventViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 27/06/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateEventViewController: UIViewController {
    
    let textFields = ["Activity Name", "Date", "Suggested Time", "Targetted Age Group", "Number of people looking for", "Location"]
    let databaseRef = FIRDatabase.database().reference().child("events")
    let currentUser = FIRAuth.auth()?.currentUser
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        let activity = databaseRef.childByAutoId()
        let eventId = activity.key
        var areAllTextFieldsFilled = true
        //iterate through text fields
        var i = 0 //
        
        // loop for alert presentation
        while i < textFields.count {
            let textFieldValue = self.view.viewWithTag(i+1) as! UITextField
            if textFieldValue.text == "" {
                var alert = UIAlertController(title: "Incomplete Event",
                message: "Please fill in all the textfields",
                preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK",
                style: .Cancel)
                { (action: UIAlertAction) -> Void in
                    //do nothing
                }
            )
            areAllTextFieldsFilled = false
            presentViewController(alert, animated: true, completion: nil)
            break
        }
        i = i + 1
        }
        if areAllTextFieldsFilled {
            var post = [String: AnyObject]()
            post["author"] = currentUser!.uid
            post["id"] = activity.key
            post["counter"] = 0
            
            FIRDatabase.database().reference().child("user_profile").child(currentUser!.uid).child("MyEvents").child(eventId).setValue(eventId)
            var dict = [String: AnyObject]()
            dict[currentUser!.uid] = currentUser!.displayName
            post["Users joined"] = (dict as! NSDictionary)
            
            i = 0
            while i < textFields.count {
                //text fields have been assigned with viewTags which start with 1
                let textFieldValue = self.view.viewWithTag(i+1) as! UITextField
                if(i != 4) {
                    let item = textFieldValue.text
                    post["\(self.textFields[i])"] = item

                } else {
                    let item = NSNumberFormatter().numberFromString(textFieldValue.text!)?.integerValue
                    post["\(self.textFields[i])"] = item

                }
                i = i + 1
            }
            activity.setValue(post as! NSDictionary)

        }
        // go back to event feed
        self.view!.endEditing(true)
        self.performSegueWithIdentifier("unwindToEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
