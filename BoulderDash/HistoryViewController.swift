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

        cell.ClimbDateLabel.text = (ServerOverlord.climbHistory)![indexPath.row]["climbdate"].stringValue
        cell.ClimbNameLabel.text = (ServerOverlord.climbHistory)![indexPath.row]["name"].stringValue
        cell.DifficultyLabel.text = "V\((ServerOverlord.climbHistory)![indexPath.row]["rating"].stringValue)"
        cell.LocationLabel.text = (ServerOverlord.climbHistory)![indexPath.row]["location"].stringValue
        cell.ExpEarnedLabel.text = (ServerOverlord.climbHistory)![indexPath.row]["exp"].stringValue
        
        cell.ClimbNameLabel.text = cell.ClimbNameLabel.text == "null" ? "Unnamed" : cell.ClimbNameLabel.text
        cell.LocationLabel.text = cell.LocationLabel.text == "null" ? "No location" : cell.LocationLabel.text
        
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
    @IBOutlet weak var DifficultyLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var ExpEarnedLabel: UILabel!
}