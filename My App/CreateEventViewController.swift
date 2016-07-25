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
        //iterate through text fields
        var i = 0 //
        while i < textFields.count {
            //text fields have been assigned with viewTags which start with 1
            let textFieldValue = self.view.viewWithTag(i+1) as! UITextField
            let item = textFieldValue.text
            activity.child("\(self.textFields[i])").setValue(item)
            i = i + 1
        }
        activity.child("author").setValue(currentUser!.uid)
        activity.child("id").setValue(activity.key)
        activity.child("counter").setValue("0")
        FIRDatabase.database().reference().child("user_profile").child(currentUser!.uid).child("MyEvents").child(eventId).setValue(eventId)
        FIRDatabase.database().reference().child("user_profile").child(currentUser!.uid).child("JoinedEvents").child(eventId).setValue(eventId)        // go back to event feed
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
