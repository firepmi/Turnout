//
//  InboxViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/4/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var imageList = [UIImage]()
    var userList = [String]()
    var messageList = [String]()
    var refStrList = [String]()
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        ref = Database.database().reference()
        imageList = [UIImage]()
        userList = [String]()
        refStrList = [String]()
        messageList = [String]()
        ref.child("chat_room").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            var k = 0;
            
            for child in snapshot.children {
                let value = child as! DataSnapshot
                let data = value.value as! Dictionary<String, Any>
                let refArr = value.key.components(separatedBy: "_")
                let user1 = refArr[1]
                let user2 = refArr[0]
                let user = Auth.auth().currentUser
                var sender:String
                if user1 == user?.uid {
                    sender = user2
                }
                else if user2 == user?.uid {
                    sender = user1
                }
                else {
                    continue
                }
                self.userList.append(sender)
                self.refStrList.append(value.key)
                let messageData = self.getLastMessage(data["messages"] as! NSDictionary)
                self.messageList.append(messageData)
                self.imageList.append(UIImage())
                self.getImage(sender, imageIndex: k)
                k+=1
            }
            
            self.tableView.reloadData()
            if( self.userList.count != 0 ){
                let indexPath = IndexPath(item: self.userList.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func getLastMessage(_ date:NSDictionary) -> String {
        let array:[[String:String]] = date.allValues as! [[String:String]]
        return array.last!["text"]!
    }
    func getImage(_ ref: String, imageIndex index:Int){
        let storage = Storage.storage()
        let storageRef = storage.reference().child( "/profile/\(ref).jpg" )
        storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
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
        return userList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID:NSString = "inboxCell";
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID as String)!
        // Configure the cell...
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID as String)
        }
        
        //        cell.contentView.layer.cornerRadius = 28.0
        let imageView:UIImageView = cell.viewWithTag(101) as! UIImageView;
        if(imageList.count > indexPath.row) {
            imageView.image = imageList[indexPath.row]
        }
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        let labe2:UILabel = cell.viewWithTag(102) as! UILabel;
        labe2.text = ""
        let labe3:UILabel = cell.viewWithTag(103) as! UILabel;
        labe3.text = self.messageList[indexPath.row]
        
        var cover:UIView = cell.viewWithTag(104) as! UIView
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

        Globals.chatRefStr = refStrList[indexPath.row]
//
        self.performSegue(withIdentifier: "toChat", sender: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

