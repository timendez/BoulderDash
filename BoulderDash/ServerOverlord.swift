//
//  ServerOverlord.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/8/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation

protocol ServerResponseDelegate {
   /*
    * Informs its delegate that the server has sent back an HTTP response.
    *
    * @sender A string representing the ServerOverlord method that called the delegate.
    *         Allows the same delegate to respond to serverDidRespond in different ways, if needed.
    */
    func serverDidRespond(sender: String)
}


/*
This class is responsible for sending and receiving requests and responses to the server.
*/
class ServerOverlord {
    
    static var delegate: ServerResponseDelegate?
    static var user: User?
    
   /*
    *
    */
    static func addClimb(name: String, loc: String, rating: Int, flash: Bool, down: Bool, campus: Bool, toe: Bool, outdoor: Bool) {
        let climbDate = NSDate()
        
        print("Sending http://boulderdash.herokuapp.com/new-climb?userId=\(user!.id)&climbName=\(name)&location=\(loc)&rating=\(rating)&outdoor=\(outdoor)&flash=\(flash)&campus=\(campus)&toetouch=\(toe)&climbDate=\(climbDate.description)")
        
        let req = NSMutableURLRequest(URL: NSURL(string: "http://boulderdash.herokuapp.com/new-climb?userId=\(user!.id)&climbName=\(name)&location=\(loc)&rating=\(rating)&outdoor=\(outdoor)&flash=\(flash)&campus=\(campus)&toetouch=\(toe)&climbDate=\(climbDate.description)")!)
        let session = NSURLSession.sharedSession()
        
        req.HTTPMethod = "POST"
         
        let download = session.dataTaskWithRequest(req, completionHandler: {
            (data, res, error) -> Void in
            
            let json = JSON(data: data!)
            
            user?.exp = json["newExp"].intValue
            user?.level = json["newLevel"].intValue
            
            self.delegate?.serverDidRespond("addClimb")
        })
        download.resume()
    }
    
   /*
    * Adds a new user to the database with id, firstName, and lastName
    */
    static func addUser() {
        print ("Sending http://boulderdash.herokuapp.com/new-user?userId=\(user!.id)&first=\(user!.firstName)&last=\(user!.lastName)")
        
        let req = NSMutableURLRequest(URL: NSURL(string: "http://boulderdash.herokuapp.com/new-user?userId=\(user!.id)&first=\(user!.firstName)&last=\(user!.lastName)")!)
        let session = NSURLSession.sharedSession()
        
        req.HTTPMethod = "POST"

        let download = session.dataTaskWithRequest(req)
        download.resume()
    }

   /*
    * Checks to see if the current facebook user is in the database.
    * If yes, gets the users level and exp from our db.
    * If no, calls addUser() and assigns level = 1 and exp = 0
    *
    * Calls delegate method serverDidRespond when finished
    */
    static func getUser() {
        print("Sending http://boulderdash.herokuapp.com/user?userId=\(user!.id)")
        let url = NSURL(string: "http://boulderdash.herokuapp.com/user?userId=\(user!.id)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)
                
                if json["name"].stringValue == "error" {
                    addUser()
                }
                user!.level = json["level"] ? json["level"].intValue : 1
                user!.exp = json["exp"] ? json["exp"].intValue : 0
                print("About to call serverDidRespond")
                delegate?.serverDidRespond("getUser")
            }
            else {
                print("ERROR: Could not fetch data in getUser")
            }
        }
        download.resume()
    }
    
   /*
    * Gets the user's friends' most recently completed climbs (the user's friend feed)
    *
    * Calls delegate method serverDidRespond when finished
    */
    static func getFriendFeed() {
        print("Sending http://boulderdash.herokuapp.com/user-feed?userIds=\(user!.friends)")
        let url = NSURL(string: "http://boulderdash.herokuapp.com/user-feed?userIds=\(user!.friends)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)
                print("Got friend feed from our DB")
                print(json)
                //delegate?.serverDidRespond("getFeed")
            }
            else {
                print("ERROR: Could not fetch data in getFriendFeed")
            }
        }
        download.resume()
    }
}

