//
//  DataManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 05/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

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
    var categories:[String]?

    var types = ["All","Sell","Donate","Barter"]
    var distances = ["All","<3km","<10km","<30km"]

    var items:[Item] = [Item]()
    
    func saveToken(token:String)->Bool{
        self.token = token
        let saveTokenSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "token")
        return saveTokenSuccessful
      
    }
    func deleteToken()->Bool{
        self.token = nil
        let removeTokenSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey:"token")
        return removeTokenSuccessful
        
    }
    
    func saveUser(user:User)->Bool{
        self.user = user
        let saveEmailSuccessful: Bool = KeychainWrapper.standard.set(user.email, forKey:"email")
        return saveEmailSuccessful
    }
    func deleteUser()->Bool{
        self.user = nil
        let removeEmailSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey:"email")
        return removeEmailSuccessful
    }
    //load user ,email and token
    func loadData(completion: @escaping () -> ()){
        token = KeychainWrapper.standard.string(forKey: "token")
        NetworkingManager.shared().setDefaultHeaders(token: token)
        let retrievedEmail: String? = KeychainWrapper.standard.string(forKey: "email")
        if let email = retrievedEmail {
            NetworkingManager.shared().fetchMyUser(email: email, completion: {
                error, data in
                if error == nil {
                    if let userData = data?["user"] as? [String : Any] {
                        let user = User(data: userData)
                        self.user = user
                    }
                }else {
                    print("error fetching user")
                }
                completion()
            })
        }
        
        

    }
    
    func loadItems(data: [String: Any]?) {
        self.items.removeAll()
        if let itemsData = data {
            if let itemsDataArr = itemsData["items"] as? [[String : Any]]{
                for itemData in itemsDataArr {
                    let item = Item(data: itemData)
                    self.items.append(item)
                }
            }
        }
    }
   
    

}
