//
//  User.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 03/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var _id = ""
    var email = ""
    var password = ""
    var name = ""
    var userAvatar = ""
    var phone = ""
    var isWhatsapp = false
    var facebook = ""
    var pushToken = ""
    
    init(data:[String:Any]) {
        if let val = data["_id"] as? String{
            _id = val
        }
        if let val = data["email"] as? String{
            email = val
        }
        if let val = data["password"] as? String{
            password = val
        }
        if let val = data["name"] as? String{
            name = val
        }
        if let val = data["userAvatar"] as? String{
            userAvatar = val
        }
        if let val = data["phone"] as? String{
            phone = val
        }
        if let val = data["isWhatsapp"] as? Bool{
            isWhatsapp = val
        }
       
        if let val = data["facebook"] as? String{
            facebook = val
        }
       
        if let val = data["pushToken"] as? String{
            pushToken = val
        }
    }
}
