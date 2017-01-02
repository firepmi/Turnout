//
//  MyProfileViewController.swift
//  Turnout
//
//  Created by Mobile World on 10/9/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import DatePickerDialog

class MyProfileViewController: UIViewController, UITextFieldDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    let picker:UIImagePickerController?=UIImagePickerController()
    var dataList = [Dictionary<String, String>]()
    var imageList = [UIImage]()
    var refStrList = [String]()
    var ref: FIRDatabaseReference!
    var alertIndicator: UIAlertController!
    var refStr:String = ""
    
    @IBOutlet weak var thumbupPercentLabel: UILabel!
    @IBOutlet weak var eventCoverView: UIView!
    @IBAction func onCreateEvent(_ sender: Any) {
    }
    @IBOutlet weak var attendedLabel: UILabel!
    @IBOutlet weak var hostedLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var thumbupBarView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func onPickImage(_ sender: Any) {
        let alert = UIAlertController(title: "Turnout", message: "Select Image From...", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { action in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {action in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        uploadMedia()
        present(alertIndicator, animated: true, completion: nil)
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        refStr = (user?.uid)!
        var chck = 5
        ref.child("profile").child(refStr).child("full_name").setValue(nameTextField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                }
            }
        }
        ref.child("profile").child(refStr).child("email").setValue(emailLabel.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                }
            }
        }
        ref.child("profile").child(refStr).child("address").setValue(addressTextField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                }
            }
        }
        ref.child("profile").child(refStr).child("phone_number").setValue(phoneNumberTextField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                }
            }
        }
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/profile/\(FIRAuth.auth()?.currentUser?.uid ?? "null").jpg" )
        let image = self.imageView.image
        if image?.ciImage == nil && image?.cgImage == nil {
            return
        }
        
        if let uploadData = UIImageJPEGRepresentation(image!, 0.8) {
            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                } else {
                    // your uploaded photo url.
                    print("Image upload complted!")
                    chck = chck - 1;
                    if(chck <= 0) {
                        self.alertIndicator.dismiss(animated: true, completion: nil)
                        //self.clearAllData();
                        //                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.delegate=self
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        phoneNumberTextField.delegate = self
       
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
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
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
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/profile/\(FIRAuth.auth()?.currentUser?.uid ?? "null").jpg" )
        storageRef.data(withMaxSize: 1 * 2048 * 2048) { (data, error) -> Void in
            if (error != nil) {
                print(error ?? "null")
            } else {
                let myImage: UIImage! = UIImage(data: data!)
                self.imageView.image = myImage
            }
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
    func refreshView(){
        addressTextField.text = Globals.address
        emailLabel.text = Globals.email_address
        nameTextField.text = Globals.name
        phoneNumberTextField.text = Globals.phone_number
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID:NSString = "profileEventTableCell";
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
        let cover:UIView = cell.viewWithTag(104)!
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Globals.index = indexPath.row
        Globals.refStr = refStrList[indexPath.row]
        Globals.detailData = dataList[indexPath.row]

        self.performSegue(withIdentifier: "profileToEvent", sender: nil)
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Image picked")
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.image = chosenImage
        
    }
    func uploadMedia() {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.isEqual(phoneNumberTextField)){
            animateViewMoving(up: true, moveValue: 60)
        }
        else if(textField.isEqual(addressTextField)){
            animateViewMoving(up: true, moveValue: 100)
        }
//        else if(textField.isEqual(passwordTextField)){
//            animateViewMoving(up: true, moveValue: 100)
//        }
//        else if(textField.isEqual(confirmPasswordTextField)){
//            animateViewMoving(up: true, moveValue: 140)
//        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.isEqual(phoneNumberTextField)){
            animateViewMoving(up: false, moveValue: 60)
        }
        else if(textField.isEqual(addressTextField)){
            animateViewMoving(up: false, moveValue: 100)
        }
//        else if(textField.isEqual(passwordTextField)){
//            animateViewMoving(up: false, moveValue: 100)
//        }
//        else if(textField.isEqual(confirmPasswordTextField)){
//            animateViewMoving(up: false, moveValue: 140)
//        }
        
    }
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
