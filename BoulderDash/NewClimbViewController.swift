//
//  NewClimbViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/7/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit

class NewClimbViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var ratings = ["V0", "V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V11", "V12", "V13", "V14", "V15", "V16"]
    
    @IBOutlet var picker: UIPickerView?
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker?.delegate = self
        picker?.dataSource = self
    }
}