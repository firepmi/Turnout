//
//  SearchViewController.swift
//  Turnout
//
//  Created by Mobile World on 12/27/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var searchIconView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var filteredDataList = [Dictionary<String, Any>]()
    var filteredIndex = [Int]()
    var dataList = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = Globals.dataList
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        updateSearchResults()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSearchResults()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateSearchResults() {
        if searchTextField.text! == "" {
            filteredDataList = dataList
            filteredIndex = [Int]()
            for i in 0 ..< dataList.count {
                filteredIndex.append(i)
            }
            searchIconView.isHidden = false
        } else {
            searchIconView.isHidden = true
            filteredDataList = [Dictionary]()
            filteredIndex = [Int]()
            var i = 0;
            for data in dataList {
                print(data["event_title"] as! String)
                if (data["event_title"] as! String).lowercased().contains(searchTextField.text!.lowercased()) ||
                    (data["name"] as! String).lowercased().contains(searchTextField.text!.lowercased()) ||
                    (data["time"] as! String).lowercased().contains(searchTextField.text!.lowercased()) ||
                    (data["location"] as! String).lowercased().contains(searchTextField.text!.lowercased()) {
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
            emptyLabel.isHidden = true
        }
        else {
            emptyLabel.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID:NSString = "searcheventcell";
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID as String)!
        // Configure the cell...
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID as String)
        }
        
        //        cell.contentView.layer.cornerRadius = 28.0
        let imageView:UIImageView = cell.viewWithTag(100) as! UIImageView;
        if(filteredIndex.count > indexPath.row && Globals.imageList.count>self.filteredIndex[indexPath.row]) {
            imageView.image = Globals.imageList[self.filteredIndex[indexPath.row]]
        }
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        let labe2:UILabel = cell.viewWithTag(101) as! UILabel;
        labe2.text = filteredDataList[indexPath.row]["event_title"] as? String;
        let labe3:UILabel = cell.viewWithTag(102) as! UILabel;
        labe3.text = filteredDataList[indexPath.row]["name"] as? String;
        let label4:UILabel = cell.viewWithTag(103) as! UILabel;
        label4.text = filteredDataList[indexPath.row]["time"] as? String;
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
        Globals.index = self.filteredIndex[indexPath.row]
        Globals.refStr = Globals.refStrList[self.filteredIndex[indexPath.row]]
        Globals.detailData = filteredDataList[indexPath.row]
        
        self.performSegue(withIdentifier: "searchToEvent", sender: nil)

    }
}

