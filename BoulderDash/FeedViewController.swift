//
//  FeedViewController.swift
//  BoulderDash
//
//  Created by Matt Versaggi on 3/1/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

protocol ViewTouchedDelegate{
    func viewWasTouched()
}

class FeedViewController: UIViewController, ViewTouchedDelegate, UITableViewDelegate, UITableViewDataSource, ServerResponseDelegate, FBSDKLoginButtonDelegate {
    let loginButton = FBSDKLoginButton()

    let levels = ["1": 0, "2": 200, "3": 400, "4": 800, "5": 1600, "6": 3200, "7": 6400, "8": 12800, "9": 25600, "10": 51200, "11": 102400, "12": 204800, "13": 409600, "14": 811200, "15": 1160000, "16": 5120000, "17": 10000000, "18": 15000000, "19": 19000000, "20": 25500000, "21": 35500000]
    
    @IBOutlet var level: UILabel?
    @IBOutlet var nameLabel: SegueLabel?
    @IBOutlet var userImage: SegueImage?
    @IBOutlet var progress: UIProgressView?
    @IBOutlet var feed: UITableView?
    
    var friendFeed: [JSON]?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerOverlord.delegate = self
        
        nameLabel?.delegate = self
        userImage?.delegate = self
        feed?.delegate = self
        feed?.dataSource = self
        
        nameLabel?.text = "\((ServerOverlord.user?.firstName)!) \((ServerOverlord.user?.lastName)!)"
        level?.text = String("Lv. \((ServerOverlord.user?.level)!)")
        progress?.setProgress(Float((ServerOverlord.user?.exp)!) / Float(levels[String((ServerOverlord.user?.level)! + 1)]!), animated: true)
        userImage?.image = ServerOverlord.user?.image
        userImage?.layer.borderWidth = 1
        userImage?.layer.borderColor = CustomColor.colorByHexString("#FF9500")
        userImage?.layer.masksToBounds = false
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
        userImage?.userInteractionEnabled = true

        ServerOverlord.getFriendFeed()
        
        let fbLoginButton: FBSDKLoginButton! = FBSDKLoginButton()
        self.view.addSubview(fbLoginButton)
        fbLoginButton.delegate = self
        fbLoginButton.center = CGPointMake(self.view.center.x / CGFloat(1.53), self.view.center.y / CGFloat(2.45))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendFeed = friendFeed {
            return friendFeed.count
        }
        else {
            return 0
        }
    }
    
    // Cell is tapped, set friend information in ServerOverlord and get climbs
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendId = friendFeed![indexPath.row]["userid"].stringValue
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
        let picture = cell.friendImage?.image!
        let first = cell.firstName
        let last = cell.lastName

        ServerOverlord.historyUser = User(firstName: first!, lastName: last!, id: friendId, image: picture!)
        ServerOverlord.isFriendHistory = true
        ServerOverlord.getHistoryUser(friendId)
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell
        let cellFriend = friendFeed![indexPath.row]

        for friend in (ServerOverlord.user?.friends)! {
            if friend["id"].stringValue == cellFriend["userid"].stringValue {
                cell.friendImage?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: NSString(string: friend["picture"]["data"]["url"].stringValue).stringByReplacingOccurrencesOfString("\\", withString: ""))!)!)
                /*cell.friendImage?.layer.borderWidth = 1
                cell.friendImage?.layer.borderColor = CustomColor.colorByHexString("#FF9500")
                cell.friendImage?.layer.masksToBounds = false
                cell.friendImage?.layer.cornerRadius = (cell.friendImage?.image!.size.width)! / 3
                cell.friendImage?.clipsToBounds = true*/
                
                // Colored text in feed
                let htmlString = "<font face=\"WalkwayBold\" color=\"#009fee\">\(friend["first_name"].stringValue) \(friend["last_name"].stringValue) completed a V\(cellFriend["rating"].stringValue) for \(cellFriend["exp"].intValue) exp! </font><font face=\"Arial\" color=\"gray\">\(getTimeAgo(cellFriend["climbdate"].stringValue))</font>"

                let encodedData = htmlString.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    cell.headline?.attributedText = attributedString
                    
                }
                catch _ {
                    print("Cannot create attributed string in user feed.")
                }
                
                cell.firstName = friend["first_name"].stringValue
                cell.lastName = friend["last_name"].stringValue
            }
        }
        return cell
    }
    
    // Calculate how long ago a climb occurred
    func getTimeAgo(occurred: NSString) -> NSString {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone(abbreviation: "GMT")!
        let currentDate = NSDate()
        let components = NSDateComponents()
        var timeAgo = ""
        components.year = Int(occurred.substringWithRange(NSRange(location: 0, length: 4)))!
        components.month = Int(occurred.substringWithRange(NSRange(location: 5, length: 2)))!
        components.day = Int(occurred.substringWithRange(NSRange(location: 8, length: 2)))!
        components.hour = Int(occurred.substringWithRange(NSRange(location: 11, length: 2)))!
        components.minute = Int(occurred.substringWithRange(NSRange(location: 14, length: 2)))!
        let date = calendar?.dateFromComponents(components)

        let betweenComponents = componentsBetweenDates(date!, endDate: currentDate)
        if betweenComponents.year > 0 {
            timeAgo += "\(String(betweenComponents.year))y"
        }
        if betweenComponents.month > 0 {
            timeAgo += "\(String(betweenComponents.month))mo"
        }
        if betweenComponents.day > 0 {
            timeAgo += "\(String(betweenComponents.day))d"
        }
        if betweenComponents.hour > 0 {
            timeAgo += "\(String(betweenComponents.hour))h"
        }
        if betweenComponents.minute > 0 {
            timeAgo += "\(String(betweenComponents.minute))m"
        }
        
        if(timeAgo == "") {
            timeAgo += "1m"
        }
        
        return "\(timeAgo) ago"
    }
    
    func componentsBetweenDates(startDate: NSDate, endDate: NSDate) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: startDate, toDate: endDate, options: [])
        
        return components
    }

    func serverDidRespond(sender: String, data: JSON) {
        if(sender == "getHistoryUser") {
            ServerOverlord.getClimbs((ServerOverlord.historyUser?.id)!)
        }
        else if(sender == "getClimbs") {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("segueToHistory", sender: self)
            }
        }
    }

    // User touched their picture or name
    func viewWasTouched() {
        ServerOverlord.isFriendHistory = false
        ServerOverlord.getClimbs((ServerOverlord.user?.id)!)
    }
    
    @IBAction func unwindFromNewClimb(segue: UIStoryboardSegue) {
        level?.text = String("Lv. \((ServerOverlord.user?.level)!)")
        progress?.setProgress(Float((ServerOverlord.user?.exp)!) / Float(levels[String((ServerOverlord.user?.level)! + 1)]!), animated: true)
        ServerOverlord.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Just Logged In")
        
        if (error != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("unwindFromFeed", sender: self)
        }
    }
}

class SegueImage: UIImageView {
    var delegate: ViewTouchedDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.viewWasTouched()
    }
}

class SegueLabel: UILabel {
    var delegate: ViewTouchedDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.viewWasTouched()
    }
}

class FeedTableViewCell: UITableViewCell {
    @IBOutlet var friendImage: UIImageView?
    @IBOutlet var headline: UILabel?
    
    var firstName: String?;
    var lastName: String?;
}

