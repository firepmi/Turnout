//
//  EditBioViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/11/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class EditBioViewController: UIViewController{
    var alertIndicator: UIAlertController!
    @IBOutlet weak var textView: UITextView!
    var ref: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        ref.child("profile").child((user?.uid)!).child("bio").setValue(textView.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        ref.child("profile").child((user?.uid)!).child("bio").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            
            if snapshot.exists() {
                self.textView.text = snapshot.value as! String
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

