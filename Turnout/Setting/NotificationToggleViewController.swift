//
//  NotificationToggleViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/16/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//
import UIKit

class NotificationToggleViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

