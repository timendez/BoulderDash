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
import FBSDKShareKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let loginButton = FBSDKLoginButton()
    
    @IBOutlet weak var userID: UITextField
    @IBOutlet weak var firstName: UITextField
    @IBOutlet weak var lastName: UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
        }
        else {
            setupLoginButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLoginButton() {
        loginButton.center = self.view.center
        loginButton.readPermissions = ["user_friends"]
        self.view.addSubview(loginButton)
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
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func addUser() {
        let req = NSMutableURLRequest(NSURL("http://boulderdash.herokuapp.com/new-user"))
    }
    
    @IBAction func getUser() {
        let req = NSMutableURLRequest(NSURL("http://boulderdash.herokuapp.com/user"))

        req.HTTPBody = NSData({"userId: 2222222222"})

        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
    }
}

