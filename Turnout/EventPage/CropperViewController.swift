//
//  CropperViewController.swift
//
//  Created by Artem Krachulov.
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit
import AKImageCropperView

final class CropperViewController: UIViewController {
    
    //  MARK: - Properties
    
    public static var image: UIImage!
    
    // MARK: - Connections:
    
    // MARK: -- Outlets
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? cropViewStoryboard
    }
    
    @IBOutlet weak var cropViewStoryboard: AKImageCropperView!
    private var cropViewProgrammatically: AKImageCropperView!
    
    @IBOutlet weak var overlayActionView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    
    // MARK: -- Actions
    
    @IBAction func backAction(_ sender: AnyObject) {
        
        guard !cropView.isEdited else {
            
            let alertController = UIAlertController(title: "Warning!", message:
                "All changes will be lost.", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: { _ in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cropImageAction(_ sender: AnyObject) {
        
         guard let image = cropView.croppedImage else {
            return
         }
        
        CropperViewController.image = image
        dismiss(animated: true, completion: nil)
         
//         let imageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
//         imageViewController.image = image
//         navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    @IBAction func showHideOverlayAction(_ sender: AnyObject) {
        
        if cropView.isOverlayViewActive {
            
            cropView.hideOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 0
                
            }, completion: nil)
            
        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    var angle: Double = 0.0
    
    @IBAction func rotateAction(_ sender: AnyObject) {

        angle += .pi/2
        
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * .pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        
        cropView.reset(animationDuration: 0.3)
        angle = 0.0
    }
    
    // MARK: -  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        cropView.delegate = self
        cropView.image = CropperViewController.image
        MyProfileViewController.state = "crop"
    }
}

//  MARK: - AKImageCropperViewDelegate

extension CropperViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
//        print("New crop rectangle: \(rect)")
    }

}
