//
//  ReviewViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/30/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImage: UILabel!
    
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    var refStr:String = ""
    var uid = ""
    
    @IBAction func onThumbUp(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("profile").child(uid).child("review").child((user?.uid)!).setValue("1"){ (error, ref) -> Void in
            if(error == nil){
                print("Thumb up!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func onThumbDown(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("profile").child(uid).child("review").child((user?.uid)!).setValue("-1"){ (error, ref) -> Void in
            if(error == nil){
                print("Thumb down!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        coverImage.layer.cornerRadius = 28
        let refArr = Globals.refStr.components(separatedBy: "_")
        uid = refArr[2]
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        
        ref.child("profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            for child in snapshot.children{
                let value = child as! DataSnapshot
                print(value.key)
                if value.key == "full_name"{
                    self.nameLabel.text = value.value as? String
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
