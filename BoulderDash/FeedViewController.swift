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

class FeedViewController: UIViewController, ViewTouchedDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var level: UILabel?
    @IBOutlet var nameLabel: SegueLabel?
    @IBOutlet var userImage: SegueImage?
    @IBOutlet var progress: UIProgressView?
    
    var friendFeed: [String]?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In Feed viewDidLoad")
        print("User has id \((ServerOverlord.user?.id)!)")
        
        nameLabel?.delegate = self
        userImage?.delegate = self
        
        nameLabel?.text = "\((ServerOverlord.user?.firstName)!) \((ServerOverlord.user?.lastName)!)"
        level?.text = String((ServerOverlord.user?.level)!)
        progress?.setProgress(0.73, animated: true)
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
        
        // Set the cell labels and user picture
        cell.headline!.text = friendFeed![indexPath.row]
//        cell.eventTime?.text =
//        cell.friendImage? = 
        
        return cell
    }
    
    func viewWasTouched() {
        performSegueWithIdentifier("segueToHistory", sender: self)
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

