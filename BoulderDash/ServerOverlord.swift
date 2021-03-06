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
    func serverDidRespond(sender: String, data: JSON)
}


/*
This class is responsible for sending and receiving requests and responses to the server.
*/
class ServerOverlord {
    
    static var delegate: ServerResponseDelegate?
    static var user: User?
    static var climbHistory: JSON?
    static var historyUser: User?
    static var isFriendHistory = false
    
   /*
    *
    */
    static func addClimb(name: String, loc: String, rating: Int, flash: Bool, down: Bool, campus: Bool, toe: Bool, outdoor: Bool) {
        let climbDate = NSDate()

        let req = NSMutableURLRequest(URL: NSURL(string: "http://boulderdash.herokuapp.com/new-climb?userId=\(user!.id)&climbName=\(name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&location=\(loc.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&rating=\(rating)&outdoor=\(outdoor)&flash=\(flash)&campus=\(campus)&down=\(down)&toetouch=\(toe)&climbDate=\((climbDate.description).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)")!)
        let session = NSURLSession.sharedSession()
        
        req.HTTPMethod = "POST"
         
        let download = session.dataTaskWithRequest(req, completionHandler: {
            (data, res, error) -> Void in
            
            let json = JSON(data: data!)

            user?.exp = json["newExp"].intValue
            user?.level = json["newLevel"].intValue
            
            self.delegate?.serverDidRespond("addClimb", data: nil)
        })
        download.resume()
    }
    
   /*
    * Adds a new user to the database with id, firstName, and lastName
    */
    static func addUser() {
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
        let url = NSURL(string: "http://boulderdash.herokuapp.com/user?userId=\(user!.id)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)
                
                if json == [] {
                    addUser()
                }
                user!.level = json[0]["level"] ? json[0]["level"].intValue : 1
                user!.exp = json[0]["exp"] ? json[0]["exp"].intValue : 0
                delegate?.serverDidRespond("getUser", data: nil)
            }
            else {
                print("ERROR: Could not fetch data in getUser")
            }
        }
        download.resume()
    }
    
    static func getHistoryUser(userId: String) {
        let url = NSURL(string: "http://boulderdash.herokuapp.com/user?userId=\(userId)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)

                historyUser!.level = json[0]["level"] ? json[0]["level"].intValue : 1
                historyUser!.exp = json[0]["exp"] ? json[0]["exp"].intValue : 0
                delegate?.serverDidRespond("getHistoryUser", data: nil)
            }
            else {
                print("ERROR: Could not fetch data in getUser")
            }
        }
        download.resume()
    }
    
    // Get the climbs of the user for the climb history
    static func getClimbs(userId: String) {
        let url = NSURL(string: "http://boulderdash.herokuapp.com/climbs?userId=\(userId)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)
                climbHistory = json
                delegate?.serverDidRespond("getClimbs", data: nil)
            }
            else {
                print("ERROR: Could not fetch data in getClimbs")
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
        var tempFriends: String = ""
        
        for (ndx, friend) in (user?.friends)!.enumerate() {
            tempFriends += friend["id"].stringValue
            if (ndx != (user?.friends?.count)! - 1) {
                tempFriends += ","
            }
        }
        
        let url = NSURL(string: "http://boulderdash.herokuapp.com/user-feed?userIds=\(tempFriends)")
        let session = NSURLSession.sharedSession()
        let download = session.dataTaskWithURL(url!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let json = JSON(data: data)
                delegate?.serverDidRespond("getFeed", data: json)
            }
            else {
                print("ERROR: Could not fetch data in getFriendFeed")
            }
        }
        download.resume()
    }
}

