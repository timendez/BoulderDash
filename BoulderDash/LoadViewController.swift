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
    var friends: JSON?

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFBFriends()
        ServerOverlord.delegate = self
    }
    
    func getFBFriends() {
        FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil) {
                let jsonFriends = JSON(result)
                self.friends = jsonFriends["data"]
            }
        })
    }

    /*
    * Delegate function that gets called when the server sends back an HTTP response.
    *
    * Fulfills ServerResponseDelegate.
    */
    func serverDidRespond(sender: String) {
        print("In serverDidRespond")
        ServerOverlord.user?.friends = friends
        self.performSegueWithIdentifier("segueToFeed", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? FeedViewController {
            print("In prepare for Segue in Load")
        }
    }
}