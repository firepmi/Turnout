//
//  TermsAndConditions.swift
//  Turnout
//
//  Created by Mobile World on 10/26/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController{    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    @IBAction func onExit(_ sender: Any) {
        if Globals.state == "setting" {
            dismiss(animated: true, completion: nil)
            Globals.state = "init"
        }
        else {
            self.performSegue(withIdentifier: "toTutor", sender: nil)
        }
    }
}
