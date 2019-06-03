//
//  Utils.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 03/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func IsDevelopment() -> Bool
    {
        let path = Bundle.main.path(forResource: "info", ofType: "plist")!
        if let dict = NSDictionary(contentsOfFile: path) {
            let isDevelopment:Bool = dict["development"] as! Bool
            return isDevelopment
        }
        return true
        
    }

   
            
     

}
