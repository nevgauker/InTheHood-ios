//
//  Message.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 21/08/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text = ""
    var userId = ""
    init(data:[String:Any]) {
        if let val = data["text"] {
            text = val  as! String
        }
        if let val = data["userId"] {
            userId = val  as! String
        }
       
    }
}
