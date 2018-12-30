//
//  PasswordViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/4/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBAction func onUpdatePassword(_ sender: Any) {
        updatePassword()
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func updatePassword(){
        let alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        present(alertIndicator, animated: true, completion: nil)
        let user = FIRAuth.auth()?.currentUser
        
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
        
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                alertIndicator.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Turnout", message: "Wrong Password! Please enter again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }else{
                //change to new password
                if self.newPasswordTextField.text == self.confirmPasswordTextField.text {
                    user?.updatePassword(self.newPasswordTextField.text!, completion: { error in
                        alertIndicator.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "Turnout", message: "Updated password successfully!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                else {
                    alertIndicator.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Turnout", message: "Password does not match", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in
                        
                    }))                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

