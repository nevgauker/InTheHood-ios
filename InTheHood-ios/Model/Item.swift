//
//  Item.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 03/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class Item: NSObject {
    var _id = ""
    var title = ""
    var price = ""
    var ownerId = ""
    var itemImage = ""
    var canBargin = false
    var currency = ""
    var locationName = ""
    var coordinates:[Float] = [Float]()
    var type = ""
    var category = ""
    var comments = ""
    var itemStatue = status.ready.rawValue
    var barterFor = ""
    
    enum status:String {
        case ready = "ready"
        case paused = "paused"
        case sold = "sold"
    }
    
    init(data:[String:Any]) {
        if let val = data["_id"] as? String{
            _id = val
        }
        
        if let val = data["title"] as? String{
            title = val
        }
        if let val = data["price"] as? NSNumber {
            price = val.stringValue
        }
        if let val = data["ownerId"] as? String{
            ownerId = val
        }
        if let val = data["itemImage"] as? String{
            itemImage = val
        }
        if let val = data["canBargin"] as? Bool{
            canBargin = val
        }
        if let val = data["currency"] as? String{
            currency = val
        }
        if let val = data["locationName"] as? String{
            locationName = val
        }
        if let val = data["coordinates"] as? [Float]{
           coordinates.append(contentsOf: val)
        }
        if let val = data["type"] as? String{
            type = val
        }
        if let val = data["category"] as? String{
            category = val
        }
        if let val = data["comments"] as? String{
            comments = val
        }
        if let val = data["status"] as? String{
            itemStatue = Item.status(rawValue: val)!.rawValue
        }
        
        if let val = data["barterFor"] as? String{
            barterFor = val
        }
    }

    
}
