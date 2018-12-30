//
//  SeekViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/26/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//


import UIKit
import Firebase

class SeekViewController: UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var ref: FIRDatabaseReference!
    var alertIndicator: UIAlertController!
    var refStr:String = ""
    var uid = ""

    let picker:UIImagePickerController?=UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = FIRAuth.auth()?.currentUser
        
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        coverView.layer.cornerRadius = 28
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
//        let refArr = Globals.refStr.components(separatedBy: "_")
//        uid = refArr[2]
//
//        if( uid < (user?.uid)! ){
//            Globals.chatRefStr = uid + "_" + (user?.uid)!
//        }
//        else {
//            Globals.chatRefStr = (user?.uid)! + "_" + uid
//        }
        uid = (user?.uid)!
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        
        ref.child("profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            for child in snapshot.children{
                let value = child as! FIRDataSnapshot
                print(value.key)
                if value.key == "full_name"{
                    self.nameLabel.text = value.value as? String
                    Globals.name = value.value as! String
                }
                else if value.key == "event_hosted"{
//                    self.hostedLabel.text = value.value as? String
                }
                else if value.key == "bio"{
                    self.bioTextView.text = value.value as? String
                }
                else if value.key == "review"{
                    let cv = value.value as! NSDictionary
                    var rv = 0;
                    for ch in cv {
                        let gValue = ch.value as! String
                        if gValue == "1" {
                            rv = rv+1;
                        }
                        else {
                            rv = rv-1;
                        }
                    }
//                    self.reviewButton.setTitle(String(rv), for: .normal)
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/profile/\(uid ?? "null").jpg" )
        storageRef.data(withMaxSize: 1 * 2048 * 2048) { (data, error) -> Void in
            if (error != nil) {
                print(error ?? "null")
            } else {
                let myImage: UIImage! = UIImage(data: data!)
                self.imageView.image = myImage
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


