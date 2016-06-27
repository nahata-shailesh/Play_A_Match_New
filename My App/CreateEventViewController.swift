//
//  CreateEventViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 27/06/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBAction func doneButtonTapped(sender: UIButton) {
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
