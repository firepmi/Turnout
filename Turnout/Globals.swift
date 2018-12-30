//
//  Globals.swift
//  Flow
//
//  Created by Mobile World on 5/28/17.
//
//

import Foundation
import UIKit

struct Globals {
    public static var name = "";
    public static var email_address = "";
    public static var phone_number = "";
    public static var address = "";
    public static var index = 0;
    public static var event_hosted = 0
    public static var refStr = ""
    public static var refStrList = [String]()
    public static var chatRefStr = ""
    public static var detailData:Dictionary<String, Any> = Dictionary()
    public static var dataList = [Dictionary<String, Any>]()
    public static var imageList = [UIImage]()
    public static var state = "init"
    public static func getImageFromLocal(_ filename:String) -> UIImage{
        let fileManager = FileManager.default
        let imagePAth = (Globals.getDirectoryPath() as NSString).appendingPathComponent(filename)
        if fileManager.fileExists(atPath: imagePAth){
            let image = UIImage(contentsOfFile: imagePAth)
            if image != nil {
                return image!
            }
            else {
                print("Invalid Image")
                return UIImage()
            }
        }else{
            print("No Image")
            return UIImage()
        }
    }
    public static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    public static func saveImageDocumentDirectory(sign: UIImage, filename:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filename)
        print(paths)
        let imageData = UIImageJPEGRepresentation(sign, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
}
