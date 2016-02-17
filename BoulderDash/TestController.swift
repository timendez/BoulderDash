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
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser() {
        if let req = NSMutableURLRequest(URL: NSURL(fileURLWithPath: "http://boulderdash.herokuapp.com/new-user")) {
            let session = NSURLSession.sharedSession()
            req.HTTPMethod = "POST"
            req.HTTPBody = NSData(base64EncodedString: "{\n\tuserId: " + userID + ",\n\tfirst: "
                                  + firstName + ",\n\tlast: " + lastName + "\n}",
                                  NSDataBase64DecodingOptions())
            let download = session.dataTaskWithRequest(req)
            
            download.resume()
        }
    }
    
    @IBAction func getUser() {
        if let url = NSURL(string: "http://boulderdash.herokuapp.com/user") {
            let session = NSURLSession.sharedSession()
            let download = session.dataTaskWithURL(url) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                // print(data)
                if let data = data {
                    dispatch_async(dispatch_get_main_queue()) {
                        print(data)
                    }
                }
                else {
                    print("Could not fetch data")
                }
                
            }
            download.resume()
        }
        else {
            print("Could not fetch URL")
        }
    }
    
}