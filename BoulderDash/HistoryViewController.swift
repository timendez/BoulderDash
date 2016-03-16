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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryTableView?.delegate = self
        HistoryTableView?.dataSource = self
        // Do any additional setup after loading the view.
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
        cell.ClimbNameLabel.text = "\((cell.ClimbNameLabel.text)!) - V\((ServerOverlord.climbHistory)![indexPath.row]["rating"].stringValue)"
        
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
        
        cell.ClimbDateLabel.text = "\(convertedDate) at \(location)"

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
    @IBOutlet weak var ExpEarnedLabel: UILabel!
}