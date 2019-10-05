//
//  Chat.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 18/09/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Chat: NSObject {
    
    var _id = ""
    var itemId = ""
    var itemOwnerId = ""
    var otherUserId = ""
    var messages:[Message] = [Message]()
    
    init(data:[String:Any]) {
        if let val = data["_id"] {
            _id = val as! String
        }
        if let val = data["itemId"] {
            itemId = val  as! String
        }
        if let val = data["itemOwnerId"] {
            itemOwnerId = val  as! String
        }
        if let val = data["otherUserId"] {
            otherUserId = val  as! String
        }
        if let val = data["messages"] as? [[String : Any]]{
            for data in val {
                let messsage:Message = Message(data: data)
                messages.append(messsage)
            }
        }
        
    }
    
}
