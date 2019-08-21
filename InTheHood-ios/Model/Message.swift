//
//  Message.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 21/08/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Message: NSObject {
    var _id = ""
    var ownerId = ""
    var itemId = ""
    var text = ""

    init(data:[String:Any]) {
        if let val = data["_id"] {
            _id = val as! String
        }
        if let val = data["ownerId"] {
            ownerId = val  as! String
        }
        if let val = data["itemId"] {
            itemId = val  as! String
        }
        if let val = data["text"] {
            text = val  as! String
        }
       
    }
}
