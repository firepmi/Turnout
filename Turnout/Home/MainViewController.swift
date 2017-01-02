//
//  ViewController.swift
//  PC Doc
//
//  Created by Polina Saar on 6/7/17.
//  Copyright © 2017 henry bermudez. All rights reserved.
//

import UIKit
import Firebase
import Dropper

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataList = [Dictionary<String, String>]()
    var imageList = [UIImage]()
    var refStrList = [String]()
    var ref: FIRDatabaseReference!
    var alertIndicator: UIAlertController!
    let dropper = Dropper(width: 180, height: 300)
    
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func onMenu(_ sender: Any) {
        if dropper.status == .hidden {
            dropper.items = ["Time", "Eating", "Drinking", "Sporting Events", "Outdoor","Performances"] // Item displayed
            dropper.theme = Dropper.Themes.white
            dropper.delegate = self as? DropperDelegate
            dropper.cornerRadius = 10
            dropper.spacing = 0
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.left, button: menuButton)
            dropper.frame.origin.x = dropper.frame.origin.x - 140
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onCreateEvent(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreatEventViewController", sender: nil)
    }
    @IBAction func onProfile(_ sender: Any) {
    }
    @IBAction func onLogOut(_ sender: Any) {
        logout()
    }
    func logout() {
        let alert = UIAlertController(title: "Turnout", message: "Do you want logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            try! FIRAuth.auth()!.signOut()
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
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
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        dataList = [Dictionary<String, String>]()
        refStrList = [String]()
        imageList = [UIImage]()
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            var k = 0;
            
            for child in snapshot.children{
                let value = child as! FIRDataSnapshot
                let data = value.value as! NSDictionary
                self.dataList.append(data as! Dictionary<String, String>)
                self.refStrList.append(value.key)
                self.imageList.append(UIImage())
                self.getImage(value.key, imageIndex: k)
                k+=1
            }
            
            self.tableView.reloadData()

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func getImage(_ ref: String, imageIndex index:Int){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/events/\(ref).jpg" )
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
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID:NSString = "eventcell";
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID as String)!
        // Configure the cell...
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID as String)
        }
        
//        cell.contentView.layer.cornerRadius = 28.0
        let imageView:UIImageView = cell.viewWithTag(100) as! UIImageView;
        if(imageList.count > indexPath.row) {
            imageView.image = imageList[indexPath.row]
        }
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        let labe2:UILabel = cell.viewWithTag(101) as! UILabel;
        labe2.text = dataList[indexPath.row]["event_title"];
        let labe3:UILabel = cell.viewWithTag(102) as! UILabel;
        labe3.text = dataList[indexPath.row]["name"];
        let label4:UILabel = cell.viewWithTag(103) as! UILabel;
        label4.text = dataList[indexPath.row]["time"];
        let cover:UIView = cell.viewWithTag(104) as! UIView
        cover.layer.cornerRadius = 28
        switch indexPath.row%4 {
        case 0:
            cover.backgroundColor = UIColorFromRGB(rgbValue: 0x6A30AF)
            break;
        case 1:
            cover.backgroundColor = UIColorFromRGB(rgbValue: 0x992FF6)
            break
        case 2:
            cover.backgroundColor = UIColorFromRGB(rgbValue: 0x8041CD)
            break
        case 3:
            cover.backgroundColor = UIColorFromRGB(rgbValue: 0x6E1EA4)
            break
        default:
            break
        }
        return cell;
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Globals.index = indexPath.row
        Globals.refStr = refStrList[indexPath.row]
        Globals.detailData = dataList[indexPath.row]
        
        self.performSegue(withIdentifier: "toEvent", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

