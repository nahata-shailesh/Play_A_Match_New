//
//  NewsFeedTableViewController.swift
//  My App
//
//  Created by Shailesh Nahata on 27/06/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseDatabase

class NewsFeedTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func unwindToEventsPage(segue: UIStoryboardSegue) {}
    
    
    @IBAction func didTapLogout(sender: UIBarButtonItem) {
        // signs the user out of the firebase app
        try! FIRAuth.auth()!.signOut()
        
        // signs the user out of the facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    let databaseRef = FIRDatabase.database().reference()
    let currentUser = FIRAuth.auth()?.currentUser
    var objectArray = [[String: AnyObject]]()
    var filteredTexts = [[String: AnyObject]]()
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTexts = objectArray.filter { event in
            return event["Activity Name"]!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    // Alternative to segueing directly from the storyboard
    
    //    @IBAction func didTapCreateButton(sender: UIBarButtonItem) {
    //        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("EventView")
    //        self.presentViewController(viewController, animated: true, completion: nil)
    //
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 0: print ("Case 0")
            case 1: print ("Case 1")
            case 2: print ("Case 2")
            case 3: print ("Case 3")
            default: break
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
        self.databaseRef.child("events").observeEventType(.Value, withBlock: { snapshot in
            self.objectArray = []
                for child in snapshot.children {
                    let snap = (child as? FIRDataSnapshot)!
                    let dict = (snap.value as! [String : AnyObject])
                    self.objectArray.append(dict)
                }   
                self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
            })
         }
		 
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        
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
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTexts.count
        }
        return self.objectArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var data = [String: AnyObject]()
        let dequeued:AnyObject = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath)
        let cell = dequeued as! UITableViewCell
        
        if searchController.active && searchController.searchBar.text != "" {
            data = filteredTexts[indexPath.row]
        } else {
            data = objectArray[indexPath.row]
        }
        //display name of event, type, and time
        
        cell.textLabel?.text = data["Activity Name"] as! String
        cell.detailTextLabel?.text = "Date: " + (data["Date"] as! String) + "  Time: " + (data["Suggested Time"]! as! String)


        return cell
    }
    
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        let arr = self.objectArray[indexPath.row]
    //        let eventDetailsTVC = EventDetailsTableViewController()
    //        eventDetailsTVC.updateUI(arr)
    //        //self.performSegueWithIdentifier("goToEventDetails", sender: indexPath)
    //
    //    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        
        if let eventDetailsTVC = destination as? EventDetailsTableViewController {
            if (segue.identifier == "goToEventDetails") {
                let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
                eventDetailsTVC.eventDetails = self.objectArray[indexPath.row]
            }
        }
    }
}

extension NewsFeedTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
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
