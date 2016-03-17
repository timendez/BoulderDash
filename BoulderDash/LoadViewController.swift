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
    var friendFeed: [JSON]?

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFBFriends()
        ServerOverlord.delegate = self
    }
    
    func getFBFriends() {
        FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(normal)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil) {
                let jsonFriends = JSON(result)
                ServerOverlord.user?.friends = jsonFriends["data"].arrayValue
                
                // Race condition fix - making it atomic
                ServerOverlord.getFriendFeed()
            }
        })
    }

    /*
    * Delegate function that gets called when the server sends back an HTTP response.
    *
    * Fulfills ServerResponseDelegate.
    */
    func serverDidRespond(sender: String, data: JSON) {
        friendFeed = data.arrayValue
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if(sender == "getFeed") {
                self.performSegueWithIdentifier("segueToFeed", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let fvcontroller = segue.destinationViewController as? FeedViewController {
            fvcontroller.friendFeed = self.friendFeed
        }
    }
}