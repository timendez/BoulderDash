//
//  TestController.swift
//  BoulderDash
//
//  Created by 458 Student 4 on 2/17/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit
import Foundation

class TestController: UIViewController {
    @IBOutlet weak var userID: UITextField
    @IBOutlet weak var firstName: UITextField
    @IBOutlet weak var lastName: UITextField
    @IBOutlet weak var result: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser() {
        let req = NSMutableURLRequest(NSURL("http://boulderdash.herokuapp.com/new-user"))
        
        print("This will add a user")
    }
    
    @IBAction func getUser() {
        let req = NSMutableURLRequest(NSURL("http://boulderdash.herokuapp.com/user"))
        
        req.HTTPBody = NSData({"userId: 2222222222"})
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            result.text = NSString(data: data, encoding: NSUTF8StringEncoding)
        }
    }

}