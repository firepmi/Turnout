//
//  ViewController.swift
//  Turnout
//
//  Created by Mobile World on 9/28/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
//import DatePickerDialog
import LocationPickerViewController

class CreateEventViewController: UIViewController, UITextFieldDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate{
    let picker:UIImagePickerController?=UIImagePickerController()
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var turnoutLimitTextField: UITextField!
    
    @IBOutlet weak var descriptionCoverView: UIView!
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var coverImage: UIView!
    var ref: DatabaseReference!
    var alertIndicator: UIAlertController!
    var refStr:String = ""
    
    @IBAction func onLocation(_ sender: Any) {
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
            var address:String = ""
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = pickedLocationItem.addressDictionary!["Name"] as? String {
                address += locationName + ", "
            }
            
//            // Street address
//            if let street = pickedLocationItem.addressDictionary!["Thoroughfare"] as? String {
//                address += street + ", "
//            }
            
            // City
            if let city = pickedLocationItem.addressDictionary!["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = pickedLocationItem.addressDictionary!["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = pickedLocationItem.addressDictionary!["Country"] as? String {
                address += country
            }

            self.locationButton.setTitle(address, for: .normal)
        }
        locationPicker.addBarButtons()
        // Call this method to add a done and a cancel button to navigation bar.
        
        let navigationController = UINavigationController(rootViewController: locationPicker)
        present(navigationController, animated: true, completion: nil)
    }
    @IBAction func onSetDatePick(_ sender: Any)
    {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.dateButton.setTitle(formatter.string(from: dt), for: .normal)
            }
        }
    }
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

    @IBAction func onPost(_ sender: Any) {
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy_HHmmss"
        let date = Date()
        let dateString1 = dateFormatter.string(from: date)
        refStr = dateString1 + "_" + (user?.uid)!
        
        var chck = 7
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child( "/events/\(refStr).jpg" )
        let image = self.imageView.image
        if image?.ciImage == nil && image?.cgImage == nil {
            let alert = UIAlertController(title: "Turnout", message: "Please select image", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        present(alertIndicator, animated: true, completion: nil)
        if let uploadData = UIImageJPEGRepresentation(image!, 0.8) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                } else {
                    // your uploaded photo url.
                    print("Image upload complted!")
                    chck = chck - 1;
                    if(chck <= 0) {
                        self.alertIndicator.dismiss(animated: true, completion: nil)
                        //self.clearAllData();
//                        self.performSegue(withIdentifier: "toBack", sender: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        ref.child("events").child(refStr).child("event_title").setValue(eventTitleTextField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        ref.child("events").child(refStr).child("name").setValue(nameLabel.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        ref.child("events").child(refStr).child("turnout_limit").setValue(turnoutLimitTextField.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        ref.child("events").child(refStr).child("location").setValue(locationButton.titleLabel?.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        ref.child("events").child(refStr).child("description").setValue(DescriptionTextView.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        ref.child("events").child(refStr).child("time").setValue(dateButton.titleLabel?.text){ (error, ref) -> Void in
            if(error == nil){
                print("print_name uploaded!")
                chck = chck - 1;
                if(chck <= 0) {
                    self.alertIndicator.dismiss(animated: true, completion: nil)
                    //self.clearAllData();
//                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        Globals.event_hosted = Globals.event_hosted + 1
        ref.child("profile").child((user?.uid)!).child("event_hosted").setValue(String(Globals.event_hosted))
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
        present(alertIndicator, animated: true, completion: nil)
        ref = Database.database().reference()
        ref.child("profile").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            for child in snapshot.children{
                let value = child as! DataSnapshot
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
            self.refreshView()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func refreshView(){
        nameLabel.text = Globals.name
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = Date()
        dateString = dateFormatter.string(from: date)
        
        dateButton.setTitle(dateString, for: .normal)
    }
    var dateString = ""
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        DescriptionTextView.delegate = self
        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
        coverImage.layer.cornerRadius = 28
        
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        descriptionCoverView.layer.cornerRadius = 28
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
        
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Image picked")
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
    }
    func uploadMedia() {
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.isEqual(DescriptionTextView)){
            animateViewMoving(up: true, moveValue: 200)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.isEqual(DescriptionTextView)){
            animateViewMoving(up: false, moveValue: 200)
        }
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

