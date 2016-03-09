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

class FeedViewController: UIViewController, ViewTouchedDelegate {
    
    @IBOutlet var level: UILabel?
    @IBOutlet var nameLabel: SegueLabel?
    @IBOutlet var userImage: SegueImage?
    @IBOutlet var progress: UIProgressView?
    
    var user: User?
    
    func viewWasTouched() {
        performSegueWithIdentifier("segueToHistory", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel?.delegate = self
        userImage?.delegate = self
        
        nameLabel?.text = "\(user?.firstName) \(user?.lastName)"
        level?.text = String(user?.level)
        progress?.setProgress(0.73, animated: true)
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