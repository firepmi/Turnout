//
//  PublicProfileViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/25/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class PublicProfileViewController: UIViewController{
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var attendedLabel: UILabel!
    @IBOutlet weak var hostedLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var thumbupBarView: UIView!
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    var refStr:String = ""
    var uid = ""
    
    @IBOutlet weak var thumbupPercentLabel: UILabel!
    @IBOutlet weak var eventCoverView: UIView!
    let picker:UIImagePickerController?=UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        
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
        attendedLabel.layer.masksToBounds = true
        hostedLabel.layer.masksToBounds = true
        attendedLabel.layer.cornerRadius = attendedLabel.frame.width/2
        hostedLabel.layer.cornerRadius = hostedLabel.frame.width/2
        eventCoverView.layer.cornerRadius = eventCoverView.frame.width/2
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        thumbupBarView.frame = CGRect.init(x: 0, y: 0, width: width*0.75/1.875, height: thumbupBarView.frame.height)
        
        let refArr = Globals.refStr.components(separatedBy: "_")
        uid = refArr[2]
        
        if( uid < (user?.uid)! ){
            Globals.chatRefStr = uid + "_" + (user?.uid)!
        }
        else {
            Globals.chatRefStr = (user?.uid)! + "_" + uid
        }
        self.hostedLabel.text = "0"
        self.reviewButton.setTitle("0", for: .normal)
        
        
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
                    Globals.name = value.value as! String
                }                
                else if value.key == "event_hosted"{
                    self.hostedLabel.text = value.value as? String
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
                    self.reviewButton.setTitle(String(rv), for: .normal)
                }
            }

        }) { (error) in
            print(error.localizedDescription)
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child( "/profile/\(uid ?? "null").jpg" )
        storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
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
    @IBAction func onReportUser(_ sender: Any) {
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

