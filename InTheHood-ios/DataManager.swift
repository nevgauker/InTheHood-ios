//
//  DataManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 05/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    private static var sharedDataManager: DataManager = {
        let dataManager = DataManager()
        return dataManager
    }()
    
    private override init() {
       
    }
    class func shared() -> DataManager {
        return sharedDataManager
    }
    
    var user:User?
    var token:String?
    
    func saveToken(){
        
    }
    func loadToken(){
        
    }
   
    

}
