//
//  ServerOverlord.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/8/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

/*
    This class is responsible for sending and receiving requests and responses to the server
*/

import Foundation

protocol ServerResponseDelegate {
    func serverDidRespond()
}

class ServerOverlord {
    
    static var delegate: ServerResponseDelegate?
    
    static func addUser(user: User) {
        let req = NSMutableURLRequest(URL: NSURL(fileURLWithPath: "http://boulderdash.herokuapp.com/new-user"))
        let session = NSURLSession.sharedSession()
        req.HTTPMethod = "POST"
        //req.HTTPBody = NSData(base64EncodedString: "{\n\tuserId: \(userID),\n\tfirst: \(firstName),\n\tlast: \(lastName)\n}", options: NSDataBase64DecodingOptions())
        let download = session.dataTaskWithRequest(req)
        
        download.resume()

    }
    
    static func getUserDetails(var user: User) {
        
        if let url = NSURL(string: "http://boulderdash.herokuapp.com/user?userId=\(user.id)") {
            let session = NSURLSession.sharedSession()
            let download = session.dataTaskWithURL(url) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let data = data {
                    let json = JSON(data: data)
                    user.level = json["level"] ? json["level"].intValue : -1
                    user.exp = json["exp"] ? json["exp"].intValue : -1
                    print("About to call serverDidRespond")
                    delegate?.serverDidRespond()
                }
                else {
                    print("Could not fetch data in getUserDetails")
                }
            }
            download.resume()
        }
        else {
            print("Could not fetch URL in getUserDetails")
        }
    }
}