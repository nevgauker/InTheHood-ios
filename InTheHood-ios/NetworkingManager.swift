//
//  NetworkingManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 02/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class API: NSObject {
    let baseURLDEV = "http://localhost:3004"
    let baseURLPROD = ""
    let defaultHeaders:[String: String] = [String :  String]()
}


class NetworkingManager: NSObject {
    
    var THE_API:API!
    let baseURL: URL?
    var categories:[String]?
    
    private static var sharedNetworkManager: NetworkingManager = {
        let THE_API  = API()
        let networkManager = NetworkingManager(api: THE_API)
        return networkManager
    }()
    
    private init(api: API) {
        self.THE_API = api
        
        var urlStr =  THE_API.baseURLPROD
        if Utils.IsDevelopment() {
            urlStr = THE_API.baseURLDEV
        }
        baseURL = URL(string: urlStr)
    }
    
    class func shared() -> NetworkingManager {
        return sharedNetworkManager
    }
    
    
    func getCategories() {
        
        

    }


}
