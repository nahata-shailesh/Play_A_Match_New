//
//  EventDetailsTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 20/07/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    var about = []
    var newArray = [String: AnyObject]()
    var objArray = [(String, AnyObject)]()
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
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToNews", sender: self)
    }
    
    @IBAction func didTapJoin(sender: UIButton) {
        print ("Button touched")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print (about)
//        print (about[1].count)
//        var ind = 0
        
        for item in about[1] as! [String: AnyObject] {
            objArray.append(item)
        }
     
        
        dispatch_async(dispatch_get_main_queue()) {
            var index = 0
            while index < self.objArray.count {
                
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let cell: ProfileDetailsTableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! ProfileDetailsTableViewCell?
                let sendString = (self.objArray[index].0 as? String)! + ": " + (self.objArray[index].1 as! String)
                cell?.configure(sendString)
                index += 1
                //self.tableView.reloadData()
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
        return self.objArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProfileDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath) as! ProfileDetailsTableViewCell
        let sendString = (self.objArray[indexPath.row].0 as? String)! + ": " + (self.objArray[indexPath.row].1 as! String)
        cell.configure(sendString)
        
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
