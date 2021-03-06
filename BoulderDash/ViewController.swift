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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, ServerResponseDelegate {
    let loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerOverlord.delegate = self

        title = "BoulderDash"

        // Facebook Login
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            beginLoadProcess()

        } else {
            let fbLoginButton: FBSDKLoginButton! = FBSDKLoginButton()
            self.view.addSubview(fbLoginButton)
            fbLoginButton.delegate = self
            fbLoginButton.center = self.view.center
            fbLoginButton.readPermissions = ["user_friends"]
        }
    }
    
    @IBAction func unwindFromFeed(segue: UIStoryboardSegue) {
        ServerOverlord.delegate = self
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
        
        if (error != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("user_friends") {
                beginLoadProcess()
            }
        }
    }
    
    /*
    * Begins the process of loading the user data from both Facebook and the DB
    */
    func beginLoadProcess() {
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(normal)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil) {
                    ServerOverlord.user = User(firstName: result["first_name"] as! String!, lastName: result["last_name"] as! String!, id: result["id"] as! String!, image: UIImage(data: NSData(contentsOfURL: NSURL(string: NSString(string: result["picture"]!!["data"]!!["url"] as! String!) as String)!)!)!)
                    ServerOverlord.getUser()
                }
                else {
                    print(error)
                }
            })
        }
    }
    
    
    // Added to stop segfault, making sure every server request is atomic
    func serverDidRespond(sender: String, data: JSON) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("segueToLoad", sender: self)
        }
    }
    
   /*
    *
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? LoadViewController {
            print("In prepareForSegue in Login")
            dest.user = user
        }
    }

    @IBAction func changeToTest(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TestController") as! TestController
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
*/
    
}