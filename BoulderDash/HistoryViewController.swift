//
//  HistoryViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/14/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    let levels = ["1": 0, "2": 200, "3": 400, "4": 800, "5": 1600, "6": 3200, "7": 6400, "8": 12800, "9": 25600, "10": 51200, "11": 102400, "12": 204800, "13": 409600, "14": 811200, "15": 1160000, "16": 5120000, "17": 10000000, "18": 15000000, "19": 19000000, "20": 25500000, "21": 35500000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryTableView?.delegate = self
        HistoryTableView?.dataSource = self
        
        // Set up metadata
        let isFriend = ServerOverlord.isFriendHistory
        let historyUser = isFriend ? ServerOverlord.historyUser! : ServerOverlord.user!

        progress?.setProgress(Float(historyUser.exp) / Float(levels[String(historyUser.level + 1)]!), animated: true)
        Name.text = "\(historyUser.firstName) \(historyUser.lastName)"
        Level.text = "Lv. \(historyUser.level)"
        ImageView.image = historyUser.image
        ImageView?.layer.borderWidth = 1
        ImageView?.layer.borderColor = CustomColor.colorByHexString("#FF9500")
        ImageView?.layer.masksToBounds = false
        ImageView?.layer.cornerRadius = (ImageView?.frame.height)!/2
        ImageView?.clipsToBounds = true
        ImageView?.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ServerOverlord.climbHistory?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as! HistoryTableViewCell

        cell.ClimbNameLabel.text = (ServerOverlord.climbHistory)![indexPath.row]["name"].stringValue
        cell.ExpEarnedLabel.text = "\((ServerOverlord.climbHistory)![indexPath.row]["exp"].stringValue) experience points earned"
        cell.ClimbNameLabel.text = cell.ClimbNameLabel.text == "null" ? "Unnamed" : cell.ClimbNameLabel.text
        
        // Name and Difficulty
        let htmlName = "<font size=5 face=\"WalkwayBold\" color=\"#009fee\">\((cell.ClimbNameLabel.text)!) <font color=\"gray\">V\((ServerOverlord.climbHistory)![indexPath.row]["rating"].stringValue)</font></font>"
        let encodedData = htmlName.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            cell.ClimbNameLabel.attributedText = attributedString
        } catch _ {
            print("Cannot create attributed string in user feed.")
        }
        
        // Making date look normal
        let components = NSDateComponents()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let dateFormatter = NSDateFormatter()
        calendar?.timeZone = NSTimeZone(abbreviation: "GMT")!
        let occurred = (ServerOverlord.climbHistory)![indexPath.row]["climbdate"].stringValue as NSString!
        components.year = Int(occurred.substringWithRange(NSRange(location: 0, length: 4)))!
        components.month = Int(occurred.substringWithRange(NSRange(location: 5, length: 2)))!
        components.day = Int(occurred.substringWithRange(NSRange(location: 8, length: 2)))!
        components.hour = Int(occurred.substringWithRange(NSRange(location: 11, length: 2)))!
        components.minute = Int(occurred.substringWithRange(NSRange(location: 14, length: 2)))!
        let date = calendar?.dateFromComponents(components)
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let convertedDate = dateFormatter.stringFromDate(date!)
        let location = (ServerOverlord.climbHistory)![indexPath.row]["location"].stringValue == "null" ? "No location" : (ServerOverlord.climbHistory)![indexPath.row]["location"].stringValue
        
        cell.ClimbDateLabel.text = "\(convertedDate)"
        cell.ClimbLocationLabel.text = "Climbed at \(location)"

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var ClimbDateLabel: UILabel!
    @IBOutlet weak var ClimbNameLabel: UILabel!
    @IBOutlet weak var ClimbLocationLabel: UILabel!
    @IBOutlet weak var ExpEarnedLabel: UILabel!
}