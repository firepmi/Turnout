//
//  LoginViewController.swift
//  PC Doc
//
//  Created by Polina Saar on 6/7/17.
//  Copyright © 2017 henry bermudez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user = FIRAuth.auth()?.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        user = FIRAuth.auth()?.currentUser
    }
    override func viewDidAppear(_ animated: Bool) {        
        if(user != nil ){
            self.performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    @IBAction func onLogin(_ sender: AnyObject) {
        let alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        present(alertIndicator, animated: true, completion: nil)
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // ...
            alertIndicator.dismiss(animated: true, completion: nil)
            if(error == nil){
                self.performSegue(withIdentifier: "toTerms", sender: nil)
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
                    let alert = UIAlertController(title:"Login Error", message: error?.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.isEqual(emailTextField)){
            animateViewMoving(up: true, moveValue: 120)
        }
        else {
            animateViewMoving(up: true, moveValue: 160)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.isEqual(emailTextField)){
            animateViewMoving(up: false, moveValue: 120)
        }
        else {
            animateViewMoving(up: false, moveValue: 160)
        }
        
    }
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
