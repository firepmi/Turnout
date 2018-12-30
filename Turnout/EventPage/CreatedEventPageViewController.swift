//
//  CreatedEventPageViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/25/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CreatedEventPageViewController: UIViewController{
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var user:FIRUser? = nil
    @IBAction func onTuronout(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        ref.child("events").child(Globals.refStr).child("attend").child((user?.uid)!).setValue("1"){ (error, ref) -> Void in
            if(error == nil){
                print("Attended!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
                self.loadData()
            }
        }
        //        ref.child("profile").child((user?.uid)!).child("event_hosted").setValue(String(Globals.event_hosted))
    }

    @IBAction func onUserProfile(_ sender: Any) {
//        self.performSegue(withIdentifier: "toUser", sender: nil)
    }
    @IBOutlet weak var descriptionCoverView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var ref: FIRDatabaseReference!
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var evenTitle: UILabel!
    
    @IBOutlet weak var nameLabel: UIButton!
    var alertIndicator: UIAlertController!
    @IBOutlet weak var dateLabel: UILabel!
    var userList = [String]()
    var imageList = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        coverView.layer.cornerRadius = 20
        descriptionCoverView.layer.cornerRadius = 20
        user = (FIRAuth.auth()?.currentUser)!
        
        downloadImage()
        nameLabel.setTitle(Globals.detailData["name"] as? String, for: .normal)
        dateLabel.text = Globals.detailData["time"] as? String
        evenTitle.text = Globals.detailData["event_title"] as? String
        descriptionTextView.text = Globals.detailData["description"] as? String
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        loadData()
    }

    @IBAction func onDeleteEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Turnout", message: "Do you want delete this event?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            try! FIRAuth.auth()!.signOut()
            Globals.event_hosted = Globals.event_hosted - 1
            self.ref.child("events").child(Globals.refStr).removeValue()
            let uid:String = self.user!.uid
            self.ref.child("profile").child(uid).child("event_hosted"
            ).setValue(String(Globals.event_hosted))
//            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onSeek(_ sender: Any) {
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        userList = [String]()
        imageList = [UIImage]()
        ref.child("events").child(Globals.refStr).child("attend").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            var k = 0;
            
            for child in snapshot.children {
                let value = child as! FIRDataSnapshot
                let data = value.value as! String
                if data == "1" {
                    self.userList.append(value.key)
                    self.imageList.append(UIImage())
                    self.getImage(value.key, imageIndex: k)
                    k+=1
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

        ref.child("profile").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            for child in snapshot.children{
                let value = child as! FIRDataSnapshot
                print(value.key)
                if value.key == "full_name"{
                    Globals.name = value.value as! String
                }
                else if value.key == "email"{
                    Globals.email_address = value.value as! String
                }
                else if value.key == "address"{
                    Globals.address = value.value as! String
                }
                else if value.key == "phone_number"{
                    Globals.phone_number = value.value as! String
                }
                else if value.key == "event_hosted"{
                    Globals.event_hosted = Int(value.value as! String)!
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getImage(_ ref: String, imageIndex index:Int){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/profile/\(ref).jpg" )
        let image = Globals.getImageFromLocal("\(ref).jpg")
        if image.ciImage != nil || image.cgImage != nil {
            if self.imageList.count <= index {
                self.imageList.append(image)
                Globals.imageList.append(image)
            }
            else {
                self.imageList[index] = image
                Globals.imageList[index] = image
            }
            return
        }
        storageRef.data(withMaxSize: 1 * 2048 * 2048) { (data, error) -> Void in
            var myImage:UIImage = UIImage()
            if (error != nil) {
                print(error ?? "null")
            } else {
                myImage = UIImage(data: data!)!
                print("Image\(index) download Successful")
            }
            if self.imageList.count <= index {
                self.imageList.append(myImage)
            }
            else {
                self.imageList[index] = myImage
            }

        }
    }
    func downloadImage(){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/events/\(Globals.refStr).jpg" )
        let image = Globals.getImageFromLocal("\(Globals.refStr).jpg")
        if image.ciImage != nil || image.cgImage != nil {
            self.imageView.image = image
            //            self.tableView.reloadData()
            return
        }
        storageRef.data(withMaxSize: 1 * 2048 * 2048) { (data, error) -> Void in
            var myImage:UIImage = UIImage()
            if (error != nil) {
                print(error ?? "null")
            } else {
                myImage = UIImage(data: data!)!
            }
            self.imageView.image = myImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


