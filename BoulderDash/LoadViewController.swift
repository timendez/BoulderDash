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
    
    var user: User?
    
    @IBOutlet var loadLabel: UILabel?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User in Load has name \(self.user?.firstName) \(self.user?.lastName) and id \(self.user?.id)")
        ServerOverlord.delegate = self
        loadLabel?.lineBreakMode = NSLineBreakMode(rawValue: 1)!
        self.updateViewConstraints()

    }
    
    /*
    * Delegate function that gets called when the server sends back an HTTP response.
    *
    * Fulfills ServerResponseDelegate.
    */
    func serverDidRespond() {
        print("In serverDidRespond")
        FBSDKGraphRequest(graphPath: "me/friends", parameters: nil).startWithCompletionHandler({
            (connection, result, error) -> Void in
            print("Back from requesting friends")
        })
        self.performSegueWithIdentifier("segueToFeed", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("In prepare for Segue in Load")
        if let dest = segue.destinationViewController as? FeedViewController {
            dest.user = user
        }
    }
}