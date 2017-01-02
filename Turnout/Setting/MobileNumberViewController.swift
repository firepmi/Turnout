//
//  MobileNumberViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/17/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class MobileNumberViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var textField: UITextField!
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    var pn = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        loadData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MobileNumberViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textField.delegate = self
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("profile").child((user?.uid)!).child("phone_number").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            
            if snapshot.exists() {
                self.textField.text = (snapshot.value as! String)
                self.pn = self.textField.text!
            }
        }) { (error) in
            print(error.localizedDescription)
        }        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        if pn == self.textField.text{
            self.dismiss(animated: true, completion: nil)
            return;
        }
        let alert = UIAlertController(title: "Turnout", message: "Do you want update phone number?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.saveData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func saveData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("profile").child((user?.uid)!).child("phone_number").setValue(textField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

