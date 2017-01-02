//
//  ReportViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/30/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class ReportViewController: UIViewController{
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var textCover: UIView!
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    var uid = ""
    @IBAction func onSubmit(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("report").child(uid).child((user?.uid)!).setValue(textView.text){ (error, ref) -> Void in
            if(error == nil){
                print("report uploaded!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        let refArr = Globals.refStr.components(separatedBy: "_")
        uid = refArr[2]
        
        coverView.layer.cornerRadius = 28
        textCover.layer.cornerRadius = 28
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
