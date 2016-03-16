//
//  HistoryViewController.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 3/14/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, ServerResponseDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerOverlord.delegate = self
        ServerOverlord.getClimbs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func serverDidRespond(sender: String, data: JSON) {
        print("HERE")
        for (_, climb) in data {
            addClimbToView(climb)
        }
    }
    
    func addClimbToView(climb: JSON) {
        
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
