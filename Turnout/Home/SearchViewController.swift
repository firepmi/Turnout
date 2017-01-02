//
//  SearchViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/27/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController{
    @IBOutlet weak var searchIconView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
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

