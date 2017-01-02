//
//  PasswordViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/4/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

