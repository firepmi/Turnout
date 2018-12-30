//
//  ViewController.swift
//  PC Doc
//
//  Created by Polina Saar on 6/7/17.
//  Copyright © 2017 henry bermudez. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UISearchResultsUpdating  {
    @IBOutlet weak var searchView: UIView!
    public var dataList = [Dictionary<String, Any>]()
    var filteredIndex = [Int]()

    @IBOutlet weak var menuView: UIView!
    var list = ["time", "eating", "drinking", "sports", "outdoors", "performances"]
    
    var filteredDataList = [Dictionary<String, Any>]()
    var searchbarEnabled = false
    
    var imageList = [UIImage]()
    var refStrList = [String]()
    var ref: FIRDatabaseReference!
    var alertIndicator: UIAlertController!
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func onMenu(_ sender: Any) {
        if menuView.isHidden {
            UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.menuView.isHidden = false
            })
        }
        else {
            UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.menuView.isHidden = true
            })
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onCreateEvent(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreatEventViewController", sender: nil)
    }
    @IBAction func onProfile(_ sender: Any) {
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        alertIndicator.view.addSubview(activityView)
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector (hideMenu))
//        self.view.addGestureRecognizer(gesture)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
       
        
        definesPresentationContext = true
//        self.view.addSubview(searchController.searchBar)
        self.searchView.addSubview(searchController.searchBar)
        searchbarEnabled = false
        
        menuView.isHidden = true
        menuView.layer.cornerRadius = 28
    }
    @IBAction func onSearch(_ sender: Any) {
//        searchView.isHidden = !searchView.isHidden
        Globals.dataList = dataList
        Globals.refStrList = refStrList
        self.performSegue(withIdentifier: "toSearch", sender: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
        let screenSize = UIScreen.main.bounds
        let rate = screenSize.height / 736
        if searchbarEnabled {
            searchView.isHidden = false
            tableView.frame = CGRect(x: 0, y: 135*rate, width: tableView.frame.width, height: screenSize.height - 114*rate)
        }
        else {
            searchView.isHidden = true
            tableView.frame = CGRect(x: 0, y: 73*rate, width: tableView.frame.width, height: screenSize.height-52*rate)
        }
    }
    static var state = "init"
    func loadData(){
        alertIndicator = UIAlertController(title: "Please Wait...", message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = CGPoint(x: 139.5, y: 75.5)
        activityView.startAnimating()
        
        alertIndicator.view.addSubview(activityView)
        if refStrList.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(self.alertIndicator, animated: true, completion: nil)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.alertIndicator.dismiss(animated: true, completion: nil)
        }
        ref = FIRDatabase.database().reference()
        dataList = [Dictionary<String, String>]()
        refStrList = [String]()
        imageList = [UIImage]()
        Globals.imageList = [UIImage]()
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            self.alertIndicator.dismiss(animated: true, completion: nil)
            var k = 0;
            self.dataList = [Dictionary<String, String>]()
            self.refStrList = [String]()
            self.imageList = [UIImage]()
            Globals.imageList = [UIImage]()
            
            for child in snapshot.children {
                let value = child as! FIRDataSnapshot
                let data = value.value as! Dictionary<String,Any>
                self.dataList.append(data)
                self.refStrList.append(value.key)
                self.imageList.append(UIImage())
                Globals.imageList.append(UIImage())
                self.getImage(value.key, imageIndex: k)
                k+=1
            }
            
            self.filteredDataList = self.dataList
            self.filteredIndex = [Int]()
            for i in 0 ..< self.dataList.count {
                self.filteredIndex.append(i)
            }
            self.filteredIndex = self.filteredIndex.sorted(by: self.dateBydate)
            self.tableView.reloadData()
            if( self.refStrList.count != 0 && MainViewController.state == "init"){
                let indexPath = IndexPath(item: self.refStrList.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                MainViewController.state = "running"
            }
            

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func dateBydate(a:Int, b:Int) -> Bool{
        let aDict = filteredDataList[a]
        let bDict = filteredDataList[b]
        let aList = (aDict["time"] as! String).split(separator: "/")
        let bList = (bDict["time"] as! String).split(separator: "/")
        
        let a1 = aList[2] + aList[0] + aList[1]
        let b1 = bList[2] + bList[0] + bList[1]
        return a1 < b1
    }
    func getImage(_ ref: String, imageIndex index:Int){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference().child( "/events/\(ref).jpg" )
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
                Globals.imageList.append(myImage)
            }
            else {
                self.imageList[index] = myImage
                Globals.imageList[index] = myImage
            }
            Globals.saveImageDocumentDirectory(sign: myImage, filename: "\(ref).jpg")
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredDataList = dataList
            filteredIndex = [Int]()
            for i in 0 ..< dataList.count {
                filteredIndex.append(i)
            }
        } else {
            filteredDataList = [Dictionary]()
            filteredIndex = [Int]()
            var i = 0;
            for data in dataList {
                print(data["event_title"] as! String)
                if (data["event_title"] as! String).lowercased().contains(searchController.searchBar.text!.lowercased()) || (data["name"] as! String).lowercased().contains(searchController.searchBar.text!.lowercased()) || (data["time"] as! String).lowercased().contains(searchController.searchBar.text!.lowercased()) {
                    filteredDataList.append(data)
                    filteredIndex.append(i)
                }
                i = i + 1;
            }
        }
        
        self.tableView.reloadData()
        if( self.filteredDataList.count != 0 ){
            let indexPath = IndexPath(item: self.filteredDataList.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataList.count;
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
        if(filteredIndex.count > indexPath.row && imageList.count>self.filteredIndex[indexPath.row]) {
            imageView.image = imageList[self.filteredIndex[indexPath.row]]
        }
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        if filteredIndex.count > indexPath.row && filteredDataList.count > filteredIndex[indexPath.row] {
            let labe2:UILabel = cell.viewWithTag(101) as! UILabel;
            labe2.text = filteredDataList[filteredIndex[indexPath.row]]["event_title"] as? String;
            let labe3:UILabel = cell.viewWithTag(102) as! UILabel;
            labe3.text = filteredDataList[filteredIndex[indexPath.row]]["name"] as? String;
            let label4:UILabel = cell.viewWithTag(103) as! UILabel;
            label4.text = filteredDataList[filteredIndex[indexPath.row]]["time"] as? String;
        }
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
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.menuView.isHidden && refStrList.count >= filteredIndex.count{
            Globals.index = self.filteredIndex[indexPath.row]
            Globals.refStr = refStrList[self.filteredIndex[indexPath.row]]
            Globals.detailData = filteredDataList[filteredIndex[indexPath.row]]
        
            self.performSegue(withIdentifier: "toEvent", sender: nil)
        }
        else {
            UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.menuView.isHidden = true
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTimeMenu(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = dataList
        filteredIndex = [Int]()
        for i in 0 ..< dataList.count {
            filteredIndex.append(i)
        }
        self.filteredIndex = self.filteredIndex.sorted(by: self.dateBydate)
        tableView.reloadData()
    }
    @IBAction func onEatingMenu(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = [Dictionary]()
        filteredIndex = [Int]()
        var i = 0;
        for data in dataList {
            if data["event_type"] != nil && data["event_type"] as! String == "eating"  {
                filteredDataList.append(data)
                filteredIndex.append(i)
            }
            i = i + 1;
        }
        tableView.reloadData()
    }
    @IBAction func onDrinkMenu(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = [Dictionary]()
        filteredIndex = [Int]()
        var i = 0;
        for data in dataList {
            if data["event_type"] != nil && data["event_type"] as! String == "drinking"  {
                filteredDataList.append(data)
                filteredIndex.append(i)
            }
            i = i + 1;
        }
        tableView.reloadData()
    }
    @IBAction func onSportingeverMenu(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = [Dictionary]()
        filteredIndex = [Int]()
        var i = 0;
        for data in dataList {
            if data["event_type"] != nil && ( data["event_type"] as! String == "sporting ever"  || data["event_type"] as! String == "sports"){
                filteredDataList.append(data)
                filteredIndex.append(i)
            }
            i = i + 1;
        }
        tableView.reloadData()
    }
    @IBAction func onOutdoorMenu(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = [Dictionary]()
        filteredIndex = [Int]()
        var i = 0;
        for data in dataList {
            if data["event_type"] != nil && data["event_type"] as! String == "outdoors"  {
                filteredDataList.append(data)
                filteredIndex.append(i)
            }
            i = i + 1;
        }
        tableView.reloadData()
    }
    @IBAction func onPerformances(_ sender: Any) {
        UIView.transition(with: menuView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.menuView.isHidden = true
        })
        filteredDataList = [Dictionary]()
        filteredIndex = [Int]()
        var i = 0;
        for data in dataList {
            if data["event_type"] != nil && data["event_type"] as! String == "performances"  {
                filteredDataList.append(data)
                filteredIndex.append(i)
            }
            i = i + 1;
        }
        tableView.reloadData()
    }
    
}
