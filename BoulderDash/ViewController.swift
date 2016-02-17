//
//  ViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 2/11/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let loginButton = FBSDKLoginButton()

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
}

