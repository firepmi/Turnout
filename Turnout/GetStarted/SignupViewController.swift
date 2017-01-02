//
//  SignupViewController.swift
//  PC Doc
//
//  Created by Polina Saar on 6/7/17.
//  Copyright © 2017 henry bermudez. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var ref: FIRDatabaseReference!
    var alertIndicator: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fullNameTextField.delegate = self;
        emailTextField.delegate = self;
        phoneNumberTextField.delegate = self;
        passwordTextField.delegate = self;
        confirmPasswordTextField.delegate = self
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignup(_ sender: AnyObject) {
        if(passwordTextField.text != confirmPasswordTextField.text){
            showDialog(message: "Password does not match! Please input again")
        }
        else if(fullNameTextField.text?.characters.count == 0 || emailTextField.text?.characters.count == 0 || phoneNumberTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0 || confirmPasswordTextField.text?.characters.count == 0){
            showDialog(message: "Please fill out all fields")
        }
        else if((passwordTextField.text?.characters.count)! < 6){
            showDialog(message: "Weak Password! please enter 6 letters more")
        }
        else {
            
            present(alertIndicator, animated: true, completion: nil)
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    self.saveData();
                    self.performSegue(withIdentifier: "SignupToTerms", sender: nil)
                    
                } else {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    func showDialog(message:String){
        let alert = UIAlertController(title:"Signup Error", message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func saveData(){
        alertIndicator.dismiss(animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        ref.child("profile").child((user?.uid)!).child("full_name").setValue(fullNameTextField.text)
        ref.child("profile").child((user?.uid)!).child("email").setValue(emailTextField.text);
        ref.child("profile").child((user?.uid)!).child("phone_number").setValue(phoneNumberTextField.text)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.isEqual(emailTextField)){
            animateViewMoving(up: true, moveValue: 20)
        }
        else if(textField.isEqual(phoneNumberTextField)){
            animateViewMoving(up: true, moveValue: 60)
        }
        else if(textField.isEqual(passwordTextField)){
            animateViewMoving(up: true, moveValue: 100)
        }
        else if(textField.isEqual(confirmPasswordTextField)){
            animateViewMoving(up: true, moveValue: 140)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.isEqual(emailTextField)){
            animateViewMoving(up: false, moveValue: 20)
        }
        else if(textField.isEqual(phoneNumberTextField)){
            animateViewMoving(up: false, moveValue: 60)
        }
        else if(textField.isEqual(passwordTextField)){
            animateViewMoving(up: false, moveValue: 100)
        }
        else if(textField.isEqual(confirmPasswordTextField)){
            animateViewMoving(up: false, moveValue: 140)
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
}
