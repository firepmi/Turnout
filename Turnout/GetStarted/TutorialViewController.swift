//
//  TutorialViewController.swift
//  Turnout
//
//  Created by Mobile World on 11/30/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController{
    
    @IBOutlet weak var viewPager: TutorialViewPager!
    
    @IBAction func onExit(_ sender: Any) {
        
    }
    
    @IBAction func onMoveRight(_ sender: Any) {
        if viewPager.currentPosition < viewPager.numberOfItems {
            viewPager.scrollToPage(index: viewPager.currentPosition+1)
        }
    }
    @IBAction func onMoveLeft(_ sender: Any) {
        if viewPager.currentPosition > 0 {
            viewPager.scrollToPage(index: viewPager.currentPosition-1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
//        viewPager.animationNext()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewPager.scrollToPage(index: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension TutorialViewController:TutorialViewPagerDataSource{
    func numberOfItems(viewPager:TutorialViewPager) -> Int {
        return 6;
    }
    
    func viewAtIndex(viewPager:TutorialViewPager, index:Int, view:UIView?) -> UIView {
        var newView = view;
        var label:UILabel?
        var imageView:UIImageView
        let imageName = "tutor\(index+1).png"
        let image = UIImage(named: imageName)
        
        if(newView == nil){
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
            newView!.backgroundColor = .randomColor()
            
            label = UILabel(frame: newView!.bounds)
            label!.tag = 1
            label!.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            label!.textAlignment = .center
            label!.font =  label!.font.withSize(28)
            newView?.addSubview(label!)
            
            
            imageView = UIImageView(image: image!)
            
            imageView.frame = viewPager.bounds
            imageView.tag = 2
            newView?.addSubview(imageView)
        }else{
            label = newView?.viewWithTag(1) as? UILabel
            imageView = newView?.viewWithTag(2) as! UIImageView
        }
        
        label?.text = "Page View Pager  \(index+1)"
        imageView.image = image
        
        return newView!
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
    
}

