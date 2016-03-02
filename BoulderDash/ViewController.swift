//
//  ViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 2/11/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let loginButton = FBSDKLoginButton()
    
    // Global State
    var isLoggedIn = false;
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BoulderDash"

        // Facebook Login
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("User logged in...")
            getFBUserData()
        } else {
            print("User not logged in...")
        }
        
        let fbLoginButton: FBSDKLoginButton! = FBSDKLoginButton()
        self.view.addSubview(fbLoginButton)
        fbLoginButton.delegate = self
        fbLoginButton.center = self.view.center
        fbLoginButton.readPermissions = ["user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("user_friends") {
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    self.user = User(firstName: result["first_name"] as! String, lastName: result["last_name"] as! String, id: result["id"] as! String, level: 0, exp: 0)
                    
                    let name: String! = result["name"] as! String
                    print("Welcome \(name)")
                    self.performSegueWithIdentifier("segueToFeed", sender: self)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func changeToTest(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TestController") as! TestController
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
}