//
//  LoadViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/9/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class LoadViewController: UIViewController, ServerResponseDelegate {

    @IBOutlet var loadLabel: UILabel?
    

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerOverlord.delegate = self
    }

    /*
    * Delegate function that gets called when the server sends back an HTTP response.
    *
    * Fulfills ServerResponseDelegate.
    */
    func serverDidRespond(sender: String) {
        print("In serverDidRespond")
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // Check if coming back from a getUser Request
            if (sender == "getUser") {
                print("About to send graphRequest")
                FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields" : "[]"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                    print("Back from requesting friends")
                    print(result)
                    ServerOverlord.user?.friends = result as! [String]
                    self.performSegueWithIdentifier("segueToFeed", sender: self)
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? FeedViewController {
            print("In prepare for Segue in Load")
        }
    }
}