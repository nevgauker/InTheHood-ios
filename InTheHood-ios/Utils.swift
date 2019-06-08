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
        if let path = Bundle.main.path(forResource: "info", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let isDevelopment:Bool = dict["development"] as! Bool
                return isDevelopment
            }
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
}
