//
//  SettingViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/3/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let listStr = ["Password", "Edit Bio","Notificatoin", "Email", "Mobile Number","Support","Terms of Service","Disable Account","See me on seek","Location","Log out"]
    let sectionList = ["My Account", "More Info","Privacy", "Account Actions"]
    let items = [["Password", "Edit Bio","Notificatoin", "Email", "Mobile Number"], ["Support","Terms of Service","Disable Account"], ["See me on seek","Location"], ["Log out"]]
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID:NSString = "settingcell";
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID as String)!
        // Configure the cell...
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID as String)
        }
        
        let labe2:UILabel = cell.viewWithTag(100) as! UILabel;
        labe2.text = items[indexPath.section][indexPath.row]

        return cell;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderSettingCell")! 
        let label:UILabel = header.viewWithTag(100) as! UILabel;
        label.text = sectionList[section]
        return header.contentView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.section][indexPath.row])
        if items[indexPath.section][indexPath.row] == "Password"{
            self.performSegue(withIdentifier: "toPassword", sender: nil)
        }
        else if items[indexPath.section][indexPath.row] == "Edit Bio"{
            self.performSegue(withIdentifier: "settingToLogin", sender: nil)
        }
        else if items[indexPath.section][indexPath.row] == "Notificatoin"{
//            self.performSegue(withIdentifier: "settingToLogin", sender: nil)
        }
        else if items[indexPath.section][indexPath.row] == "Email"{
            
        }
        else if items[indexPath.section][indexPath.row] == "Mobile Number"{
            
        }
        else if items[indexPath.section][indexPath.row] == "Support"{
            
        }
        else if items[indexPath.section][indexPath.row] == "Terms of Service"{
            self.performSegue(withIdentifier: "settingToTerm", sender: nil)
        }
        else if items[indexPath.section][indexPath.row] == "Disable Account"{
            
        }
        else if items[indexPath.section][indexPath.row] == "See me on seek"{
            
        }
        else if items[indexPath.section][indexPath.row] == "Location"{
            
        }
        else if items[indexPath.section][indexPath.row] == "Log out"{
            logOut()
        }
    }

    func logOut(){
        let alert = UIAlertController(title: "Turnout", message: "Do you want logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
            try! FIRAuth.auth()!.signOut()
            self.performSegue(withIdentifier: "settingToLogin", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

