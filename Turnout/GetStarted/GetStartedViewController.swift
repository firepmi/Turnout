//
//  GetStartedViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/15/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class GetStartedViewController: UIViewController{
    @IBOutlet weak var fbButton: UIButton!
    var ref: FIRDatabaseReference!
    @IBAction func onFBLogin(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: 139.5, y: 75.5)
            activityView.startAnimating()
            alertIndicator.view.addSubview(activityView)
            self.present(alertIndicator, animated: true, completion: nil)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, httpMethod: "GET").start(completionHandler: {(connection, result, error) in
                if ((error) != nil)
                {
                    print("Error: \(String(describing: error))")
                    alertIndicator.dismiss(animated: true, completion: nil)
                }
                else
                {
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    print(data["name"] ?? "null")
                    print(data["email"] ?? "null")
                    Globals.email_address = data["email"] as! String
                    Globals.name = data["name"] as! String
//                    Globals.phone_number = data["phone"] as! String
                    
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
                    // Perform login by calling Firebase APIs
                    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                        alertIndicator.dismiss(animated: true, completion: nil)
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                            return
                        }
                        
                        // Present the main view
                        self.performSegue(withIdentifier: "startToLogin", sender: nil)
                        //                self.dismiss(animated: true, completion: nil)
                        
                        self.saveData()
                    })
                }
            })
            
            
        }
        
    }
    func saveData(){
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        ref.child("profile").child((user?.uid)!).child("full_name").setValue(Globals.name)
        ref.child("profile").child((user?.uid)!).child("email").setValue(Globals.email_address);
//        ref.child("profile").child((user?.uid)!).child("phone_number").setValue(Globals.phone_number)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
