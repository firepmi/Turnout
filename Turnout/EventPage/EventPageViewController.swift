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
import HFSwipeView

class EventPageViewController: UIViewController{
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func onTuronout(_ sender: Any) {
       
    }
    @IBOutlet weak var descriptionCoverView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var ref: DatabaseReference!
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var evenTitle: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var alertIndicator: UIAlertController!
    @IBOutlet weak var dateLabel: UILabel!
    /////////////////////////////
    fileprivate let sampleCount: Int = 10
    fileprivate var didSetupConstraints: Bool = false
    
    fileprivate lazy var swipeView: HFSwipeView = {
        let view = HFSwipeView.newAutoLayout()
        view.autoAlignEnabled = true
        view.circulating = false
        view.dataSource = self as! HFSwipeViewDataSource
        view.delegate = self as! HFSwipeViewDelegate
        view.pageControlHidden = true
        return view
    }()
    fileprivate var currentView: UIView?
    fileprivate var itemSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    fileprivate var swipeViewFrame: CGRect {
        return CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    ////////////////////////////////////
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
        nameLabel.text = Globals.detailData["name"]
        dateLabel.text = Globals.detailData["time"]
        evenTitle.text = Globals.detailData["event_title"]
        descriptionTextView.text = Globals.detailData["description"]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toUser))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(tap)
        
        view.addSubview(swipeView)
    }
    @objc func toUser(sender:UITapGestureRecognizer){
        self.performSegue(withIdentifier: "toUser", sender: nil)
    }
    func downloadImage(){
        let storage = Storage.storage()
        let storageRef = storage.reference().child( "/events/\(Globals.refStr).jpg" )
        storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
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
    //////////////////////////////////////////
    override func updateViewConstraints() {
        if !didSetupConstraints {
            swipeView.autoSetDimension(.height, toSize: itemSize.height)
            swipeView.autoPinEdge(toSuperviewEdge: .leading)
            swipeView.autoPinEdge(toSuperviewEdge: .trailing)
            swipeView.autoAlignAxis(toSuperviewAxis: .horizontal)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.swipeView.setBorder(1, color: .black)
    }
    
    func updateCellView(_ view: UIView, indexPath: IndexPath, isCurrent: Bool) {
        
        if let label = view as? UILabel {
            
            label.backgroundColor = isCurrent ? .yellow : .white
            
            if isCurrent {
                // old view
                currentView?.backgroundColor = .white
                currentView = label
            }
            
            label.textAlignment = .center
            label.text = "\(indexPath.row)"
//            label.setBorder(1, color: .black)
            
        } else {
            assertionFailure("failed to retrieve UILabel for index: \(indexPath.row)")
        }
    }
    ////////////
}

