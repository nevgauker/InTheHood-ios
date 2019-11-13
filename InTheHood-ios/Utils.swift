//
//  Utils.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 03/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func IsDevelopment() -> Bool{
        
        guard let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return true }
        //load the plist as data in memory
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return true  }
        //use the format of a property list (xml)
        var format = PropertyListSerialization.PropertyListFormat.xml
        //convert the plist data to a Swift Dictionary
        guard let  plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String : AnyObject] else { return true }
        //access the values in the dictionary
        if let value = plistDict["development"] as? Bool {
            //do something with your value
            return value
        }
        return true
    }
    
    class func currenciesNames() -> [String]{
       return ["$","€"]
    }
    
    class func currenciesStrings() -> [String]{
      return ["USD","EURO"]
    }
    
    class func getImagePicker(library:Bool, delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate)->UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        if library {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
            }
            else {
                return nil
            }
        }else {
             if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            }
             else {
                return nil
            }
        }
        return imagePicker

    }
    
    class func fillColor()->UIColor {
        return UIColor(red: 82.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    
    class func imageWithImage(image:UIImage ,scaledToSize newSize:CGSize)-> UIImage
    {
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage
    }
}
