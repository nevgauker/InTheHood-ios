//
//  NetworkingManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 02/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class API: NSObject {
    let baseURL = ""
}


class NetworkingManager: NSObject {
    
    private static var sharedNetworkManager: NetworkingManager = {
        let url =  URL(string: "")
        let networkManager = NetworkingManager(baseURL: url!)
        return networkManager
    }()
    
    let baseURL: URL
    
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    class func shared() -> NetworkingManager {
        return sharedNetworkManager
    }


}
