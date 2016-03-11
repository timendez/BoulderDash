//
//  NewClimbViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/7/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit

class NewClimbViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ServerResponseDelegate {
    var ratings = ["V0", "V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V11", "V12", "V13", "V14", "V15", "V16"]
    
    @IBOutlet var picker: UIPickerView?
    
    @IBOutlet var climbName: UITextField?
    @IBOutlet var location: UITextField?

    @IBOutlet var flashed: UISwitch?
    @IBOutlet var downclimb: UISwitch?
    @IBOutlet var campus: UISwitch?
    @IBOutlet var toetouch: UISwitch?
    @IBOutlet var outdoor: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker?.delegate = self
        picker?.dataSource = self
        //ServerOverlord.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row]
    }
    
    func serverDidRespond(sender: String) {
        if sender == "addClimb" {
            performSegueWithIdentifier("backFromNewClimb", sender: self)
        }
    }
    
    @IBAction func newClimb() {
        ServerOverlord.addClimb((climbName?.text)!, loc: (location?.text)!, rating: (picker?.selectedRowInComponent(0))!, flash: (flashed?.selected)!, down: (downclimb?.selected)!, campus: (campus?.selected)!, toe: (toetouch?.selected)!, outdoor: (outdoor?.selected)!)
    }
}

