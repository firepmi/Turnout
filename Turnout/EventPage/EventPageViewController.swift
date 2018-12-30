//
//  EventPageViewController.swift
//  Turnout
//
//  Created by Mobile World on 10/29/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EventPageViewController: UIViewController{
    @IBOutlet weak var viewPager: ViewPager!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func onTuronout(_ sender: Any) {
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        ref.child("events").child(Globals.refStr).child("attend").child((user?.uid)!).setValue("1"){ (error, ref) -> Void in
            if(error == nil){
                print("Attended!")
                self.alertIndicator.dismiss(animated: true, completion: nil)
                self.loadData()
            }
        }
//        ref.child("profile").child((user?.uid)!).child("event_hosted").setValue(String(Globals.event_hosted))
    }
    @IBAction func onLeftButton(_ sender: Any) {
        if viewPager.currentPosition > 0 {
            viewPager.scrollToPage(index: viewPager.currentPosition-1)
        }
    }
    @IBAction func onRightButton(_ sender: Any) {
        if viewPager.currentPosition < viewPager.numberOfItems {
            viewPager.scrollToPage(index: viewPager.currentPosition+1)
        }
    }
    @IBAction func onUserProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "toUser", sender: nil)
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
        
        downloadImage()
        nameLabel.setTitle(Globals.detailData["name"] as? String, for: .normal)
        dateLabel.text = Globals.detailData["time"] as? String
        evenTitle.text = Globals.detailData["event_title"] as? String
        descriptionTextView.text = Globals.detailData["description"] as? String
        locationLabel.text = Globals.detailData["location"] as? String
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        viewPager.dataSource = self;
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewPager.scrollToPage(index: 1)
        viewPager.scrollToPage(index: 0)
    }
    func loadData(){
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
            self.viewPager.reloadData()
            
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
            }
            else {
                self.imageList[index] = image
            }
            //            self.tableView.reloadData()
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
            Globals.saveImageDocumentDirectory(sign: myImage, filename: "\(ref).jpg")
            self.viewPager.reloadViews(index: index / 4)
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
extension EventPageViewController:ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return (userList.count+3)/4;
    }
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        var newView = view;
        var label:UILabel?
        var imageView1:UIImageView
        var imageView2:UIImageView
        var imageView3:UIImageView
        var imageView4:UIImageView
        if(newView == nil){
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
            newView!.backgroundColor = UIColor(red:   0,
                                               green: 0,
                                               blue:  0,
                                               alpha: 0)
            label = UILabel(frame: newView!.bounds)
            label!.tag = 1
            label!.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            label!.textAlignment = .center
            label!.font =  label!.font.withSize(10)
            
            let w:CGFloat = viewPager.frame.width / 4
            let h:CGFloat = viewPager.frame.height
            
            imageView1 = UIImageView(frame: CGRect(x:5, y:5, width: w-10, height:w-10))
            imageView2 = UIImageView(frame: CGRect(x:w+5, y:5, width: w-10, height:w-10))
            imageView3 = UIImageView(frame: CGRect(x:w*2+5, y:5, width: w-10, height:w-10))
            imageView4 = UIImageView(frame: CGRect(x:w*3+5, y:5, width: w-10, height:w-10))
            
            imageView1.tag = 101
            imageView2.tag = 102
            imageView3.tag = 103
            imageView4.tag = 104
            
            imageView1.backgroundColor = UIColor.white
            imageView2.backgroundColor = UIColor.white
            imageView3.backgroundColor = UIColor.white
            imageView4.backgroundColor = UIColor.white
            
            newView?.addSubview(imageView1)
            newView?.addSubview(imageView2)
            newView?.addSubview(imageView3)
            newView?.addSubview(imageView4)
//            newView?.addSubview(label!)
        }else{
            label = newView?.viewWithTag(1) as? UILabel
            
            imageView1 = newView?.viewWithTag(101) as! UIImageView
            imageView2 = newView?.viewWithTag(102) as! UIImageView
            imageView3 = newView?.viewWithTag(103) as! UIImageView
            imageView4 = newView?.viewWithTag(104) as! UIImageView
        }
        
        label?.text = "Page View Pager  \(index+1)"
        
        if(self.imageList.count > (index * 4)) {
            imageView1.image = self.imageList[index*4]
        }
        else {
            imageView1.isHidden = true
        }
            
        if(self.imageList.count > (index * 4+1)) {
            imageView2.image = self.imageList[index*4+1]
        }
        else {
            imageView2.isHidden = true
        }
        if(self.imageList.count > (index * 4+2)) {
            imageView3.image = self.imageList[index*4+2]
        }
        else {
            imageView3.isHidden = true
        }
        if(self.imageList.count > (index * 4+3)) {
            imageView4.image = self.imageList[index*4+3]
        }
        else {
            imageView4.isHidden = true
        }
        imageView1.layer.borderWidth = 1
        imageView1.layer.masksToBounds = false
        imageView1.layer.borderColor = UIColor.black.cgColor
        imageView1.layer.cornerRadius = imageView1.frame.height/2
        imageView1.clipsToBounds = true
        
        imageView2.layer.borderWidth = 1
        imageView2.layer.masksToBounds = false
        imageView2.layer.borderColor = UIColor.black.cgColor
        imageView2.layer.cornerRadius = imageView1.frame.height/2
        imageView2.clipsToBounds = true

        imageView3.layer.borderWidth = 1
        imageView3.layer.masksToBounds = false
        imageView3.layer.borderColor = UIColor.black.cgColor
        imageView3.layer.cornerRadius = imageView1.frame.height/2
        imageView3.clipsToBounds = true

        imageView4.layer.borderWidth = 1
        imageView4.layer.masksToBounds = false
        imageView4.layer.borderColor = UIColor.black.cgColor
        imageView4.layer.cornerRadius = imageView1.frame.height/2
        imageView4.clipsToBounds = true
        
        return newView!
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
}
extension UIColor {
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

