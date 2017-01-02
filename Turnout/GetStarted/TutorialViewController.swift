//
//  TutorialViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/30/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func onExit(_ sender: Any) {
    }
    var imageIndex:NSInteger = 0
    var maximages = 5
    var imageList: [String] = ["tutorial1.png", "tutorial2.png", "tutorial3.png", "tutorial4.png", "tutorial5.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped)) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped)) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        imageView.image = UIImage(named:"tutorial1.png")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right :
                print("User swiped right")
                
                // decrease index first
                
                imageIndex -= 1
                
                // check if index is in range
                
                if imageIndex <= 0 {
                    
                    imageIndex = maximages
                }
                
                imageView.image = UIImage(named: imageList[imageIndex])
                
            case UISwipeGestureRecognizerDirection.left:
                print("User swiped Left")
                
                // increase index first
                
                imageIndex += 1
                
                // check if index is in range
                
                if imageIndex >= maximages {
                    
                    imageIndex = 0
                }
                
                imageView.image = UIImage(named: imageList[imageIndex])
                
            default:
                break //stops the code/codes nothing.
            }
        }
    }
}
