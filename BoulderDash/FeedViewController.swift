//
//  FeedViewController.swift
//  BoulderDash
//
//  Created by Matt Versaggi on 3/1/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit

protocol ViewTouchedDelegate{
    func viewWasTouched()
}

class FeedViewController: UIViewController, ViewTouchedDelegate, UITableViewDelegate, UITableViewDataSource, ServerResponseDelegate {
    
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
        
        print("In Feed viewDidLoad")
        print("User has id \((ServerOverlord.user?.id)!)")
        
        nameLabel?.delegate = self
        userImage?.delegate = self
        feed?.delegate = self
        feed?.dataSource = self
        
        nameLabel?.text = "\((ServerOverlord.user?.firstName)!) \((ServerOverlord.user?.lastName)!)"
        level?.text = String((ServerOverlord.user?.level)!)
        progress?.setProgress(Float((ServerOverlord.user?.exp)!) / Float(levels[String((ServerOverlord.user?.level)! + 1)]!), animated: true)

        ServerOverlord.getFriendFeed()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendFeed = friendFeed {
            return friendFeed.count
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell
        let cellFriend = friendFeed![indexPath.row]
        
        for friend in (ServerOverlord.user?.friends)! {
            if friend["id"].stringValue == cellFriend["userid"].stringValue {
                cell.friendImage?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: NSString(string: friend["picture"]["data"]["url"].stringValue).stringByReplacingOccurrencesOfString("\\", withString: ""))!)!)
                cell.headline?.text = "\(friend["first_name"].stringValue) \(friend["last_name"].stringValue) completed a V\(cellFriend["rating"].stringValue) for \(cellFriend["exp"].intValue) exp"
            }
        }

        // Set the cell labels and user picture
//        cell.headline!.text = friendFeed![indexPath.row]
        cell.eventTime?.text = "5m ago"

        print("Returning a cell")
        
        return cell
    }

    func serverDidRespond(sender: String, data: JSON) {
        print("Coming back from getting friend feed")
        print(data)
        friendFeed = data.arrayValue
    }

    func viewWasTouched() {
        performSegueWithIdentifier("segueToHistory", sender: self)
    }
    
    @IBAction func unwindFromNewClimb(segue: UIStoryboardSegue) {
        level?.text = String((ServerOverlord.user?.level)!)
        progress?.setProgress(Float((ServerOverlord.user?.exp)!) / Float(levels[String((ServerOverlord.user?.level)! + 1)]!), animated: true)
        ServerOverlord.delegate = self
    }
}

class SegueImage: UIImageView {
    var delegate: ViewTouchedDelegate?
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
    @IBOutlet var eventTime: UILabel?
}

