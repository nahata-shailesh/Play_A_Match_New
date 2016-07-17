    //
    //  ViewController.swift
    //  My App
    //
    //  Created by Shailesh Nahata on 26/06/16.
    //  Copyright © 2016 Shailesh Nahata. All rights reserved.
    //

    import UIKit
    import FBSDKCoreKit
    import FBSDKLoginKit
    import FirebaseAuth

    class ViewController: UIViewController, FBSDKLoginButtonDelegate
    {
        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
        

        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
           self.loginButton.hidden = true
            
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    // User is signed in.
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("TabBarController")
                    self.presentViewController(tableViewController, animated: true, completion: nil)
                    
                } else {
                    // No user is signed in.
                    self.loginButton.center = self.view.center
                    self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                    self.loginButton.delegate = self
                    self.view!.addSubview(self.loginButton)
                    self.loginButton.hidden = false
                }
            }
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

            print("User Logged In")
            
            self.loginButton.hidden = true
            
            
            if error != nil {
                //handle errors here
                self.loginButton.hidden = false
                
                
            } else if result.isCancelled {
                // handle cancel event
                self.loginButton.hidden = false
                
                
            } else {
                
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("Logged in to Firebase App")
                }
                
            }
        }
        
        func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
            print("User Logged Out")
        }


    }

