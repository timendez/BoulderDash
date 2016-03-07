//
//  FeedViewController.swift
//  BoulderDash
//
//  Created by Matt Versaggi on 3/1/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet var nameLabel: SegueLabel?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
}

class SegueLabel: UILabel {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(superview)
    }
}