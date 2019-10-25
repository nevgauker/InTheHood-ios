//
//  NetworkingManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 02/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//


import Alamofire

class API: NSObject {
    
    let baseURLDEV_SIMULATOR = "http://localhost:3004/"
    let baseURLDEV_DEVICE = "http://192.168.179.146:3004/"
    let baseURLPROD = "https://inthehoodapi.herokuapp.com/"
    var defaultHeaders:HTTPHeaders = HTTPHeaders()
}


class NetworkingManager: NSObject {
    
    var THE_API:API!
    var baseUrlStr: String!
    
    
    private static var sharedNetworkManager: NetworkingManager = {
        let THE_API  = API()
        let networkManager = NetworkingManager(api: THE_API)
        return networkManager
    }()
    
    private init(api: API) {
        self.THE_API = api
        baseUrlStr =  THE_API.baseURLPROD
        if Utils.IsDevelopment() {
            #if targetEnvironment(simulator)
            baseUrlStr = THE_API.baseURLDEV_SIMULATOR
            // your simulator code
            #else
            baseUrlStr = THE_API.baseURLDEV_DEVICE
            // your real device code
            #endif
        }
    }
    
    class func shared() -> NetworkingManager {
        return sharedNetworkManager
    }
    
    func setDefaultHeaders(token:String?) {
        if let theToken = token {
            self.THE_API.defaultHeaders["Content-type"] = "application/json"
            self.THE_API.defaultHeaders["Authorization"] = "Bearer " + theToken
        }
    }
    
    //MARK: categories
    func getCategories() {
        
        let urlStr = baseUrlStr  + "categories"
        
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        
                        if let arr = dict["categories"]  as? [String] {
                            DataManager.shared().categories = arr
                        }
                    }
                }
                else {
                    print(response.error?.localizedDescription ?? "")
                }
        }
    }
    
    
    //MARK: users

    func signin(email:String, password:String?,facebookToken:String?,googleToken:String?, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "users/user/signin"
        var params = ["email": email]
        
        
        if let thePassword = password {
            params["password"] = thePassword
        }else if let token = facebookToken {
            params["facebookToken"] = token
        }else if let token = googleToken {
            params["googleToken"] = token
        }
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["message"] as? String == "Auth successful" {
                            completion(nil, dict)
                        }else {
                            completion(dict["error"] as? String,nil)
                        }
                }
                else {
                        print(response.error?.localizedDescription ?? "")
                        completion(response.error?.localizedDescription, nil)
                    }
                }
        }
    }
    
    func signup(email:String,password:String,name:String,avatar:UIImage, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()){

        let params = [
            "email": email,
            "password" : password,
            "name" : name
        ]
        
        let urlStr = baseUrlStr + "users/user/signup"
        //Header HERE
//        let headers = [
//            "Content-type": "multipart/form-data",
//            "Content-Disposition" : "form-data"
//        ]
        
        let imgData:Data =  avatar.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imgData, withName:  "userAvatar", fileName: "userAvatar.jpg", mimeType:  "image/jpeg")

            
        }, usingThreshold:UInt64.init(),
           to: urlStr, //URL Here
            method: .post,
            headers: nil, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                    })
                    
                    upload.responseJSON { response in
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response)")
                        if let dict = response.result.value as? Dictionary<String,AnyObject>{
                            if dict["message"] as! String == "Auth successful" {
                                completion(nil, dict)
                            }else {
                                completion(dict["error"] as? String,nil)
                            }
                        }else {
                            completion(nil, nil)
                        }
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    completion(encodingError.localizedDescription, nil)
                    break
                }
        })
    }
    
    //auth
    func fetchMyUser(email:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()){
        let urlStr = baseUrlStr  + "users/user/me"
        let params = ["email": email]
        let headers = self.THE_API.defaultHeaders
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil && dict["error"] as! String == "Auth failed" {
                            self.hanleAuthFail()
                             completion(dict["error"] as? String, nil)
                        }else {
                            completion(nil,dict)
                        }
                    }else {
                        completion(nil, nil)
                    }
                }else {
                     completion(response.error?.localizedDescription, nil)
                }
        }
    }
    //update my user push token
    func updateMyUserPush(email:String,token:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()){
        let urlStr = baseUrlStr  + "users/user/me/push"
        let params = ["email": email, "pushToken":token]
        let headers = self.THE_API.defaultHeaders
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil && dict["error"] as! String == "Auth failed" {
                            self.hanleAuthFail()
                            completion(dict["error"] as? String, nil)
                        }else {
                            completion(nil,dict)
                        }
                    }else {
                        completion(nil, nil)
                    }
                }else {
                    completion(response.error?.localizedDescription, nil)
                }
        }
    }
    
    func fetchUser(_id:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()){
        let urlStr = baseUrlStr  + "users/user/" + _id

        let headers = self.THE_API.defaultHeaders
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil && dict["error"] as! String == "Auth failed" {
                            self.hanleAuthFail()
                            completion(dict["error"] as? String, nil)
                        }else {
                            completion(nil,dict)
                        }
                    }else {
                        completion(nil, nil)
                    }
                }else {
                    completion(response.error?.localizedDescription, nil)
                }
        }
    }
    
    //MARK: items
    
    //auth
    func getItems(location:[String : Double]?, distance: Float,type:String,category:String,completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
       
        

        var params = ["distance" : distance,
            ] as [String : Any]
        
        if let loc = location {
            params["location"] = loc
            
        }
        
    let urlStr = baseUrlStr  + "items"
    params["type"] = type
    params["category"] = category


    Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            //print(dict["error"] as! String)
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }

            
                }else {
                    print(response.error?.localizedDescription ?? "")
                        completion(response.error?.localizedDescription, nil)

                
                
                }
        }
    }
    
    func deleteItem(_id:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        
        let urlStr = baseUrlStr  + "items/item/" + _id

        var headers = THE_API.defaultHeaders
        headers["Content-type"] = nil
        Alamofire.request(urlStr, method: .delete, parameters: nil, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            //print(dict["error"] as! String)
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }else {
                    print(response.error?.localizedDescription ?? "")
                    completion(response.error?.localizedDescription, nil)
                    
                }
        }
    }

    
    
    func createItem(params:[String:String], itemImage:UIImage, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "items/item/add"
        var headers = THE_API.defaultHeaders
        headers["Content-type"] = nil
    
        let imgData:Data =  itemImage.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imgData, withName:  "itemImage", fileName: "itemImage.jpg", mimeType:  "image/jpeg")
            
        }, usingThreshold:UInt64.init(),
           to: urlStr, //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                    })
                    
                    upload.responseJSON { response in
                        
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response)")
                        if let dict = response.result.value as? Dictionary<String,AnyObject>{
                            if dict["error"] != nil {
                                print(dict["error"] as! String)
                                if  dict["error"] as! String == "Auth failed"{
                                    self.hanleAuthFail()
                                }
                                completion( dict["error"] as? String, nil)
                            }else {
                                completion(nil, dict)
                            }
                        } else {
                            completion(nil, nil)
                        }
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    completion(encodingError.localizedDescription, nil)
                    break
                }
        })
    }
    
    func updateItem(_id:String,params:[String:String], itemImage:UIImage, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "items/item/" + _id
        var headers = THE_API.defaultHeaders
        headers["Content-type"] = nil
        
        let imgData:Data =  itemImage.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imgData, withName:  "itemImage", fileName: "itemImage.jpg", mimeType:  "image/jpeg")
            
        }, usingThreshold:UInt64.init(),
           to: urlStr, //URL Here
            method: .patch,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                    })
                    
                    upload.responseJSON { response in
                        
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response)")
                        if let dict = response.result.value as? Dictionary<String,AnyObject>{
                            if dict["error"] != nil {
                                print(dict["error"] as! String)
                                if  dict["error"] as! String == "Auth failed"{
                                    self.hanleAuthFail()
                                }
                                completion( dict["error"] as? String, nil)
                            }else {
                                completion(nil, dict)
                            }
                        } else {
                            completion(nil, nil)
                        }
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    completion(encodingError.localizedDescription, nil)
                    break
                }
        })
    }
    
    
    
    
    //MARK: messages
//
//    func createMessage(params:[String:String], completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
//
//        let urlStr = baseUrlStr  + "messages/message/add"
//        var headers = THE_API.defaultHeaders
//        headers["Content-type"] = nil
//
//        Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
//            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                print("Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                if response.error == nil {
//                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
//                        if dict["error"] != nil {
//                            //print(dict["error"] as! String)
//                            if  dict["error"] as! String == "Auth failed"{
//                                self.hanleAuthFail()
//                            }
//                            completion( dict["error"] as? String, nil)
//                        }else {
//                            completion( nil, dict)
//                        }
//                    } else {
//                        completion(nil, nil)
//                    }
//
//
//                }else {
//                    print(response.error?.localizedDescription ?? "")
//                    completion(response.error?.localizedDescription, nil)
//
//                }
//        }
//    }
    
//    func fetchMessagesByOwner(_id:String,completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
//
//        let urlStr = baseUrlStr  + "messages/owner/" + _id
//        var headers = THE_API.defaultHeaders
//        headers["Content-type"] = nil
//
//        Alamofire.request(urlStr, method: .get, parameters: nil, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
//            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                print("Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                if response.error == nil {
//                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
//                        if dict["error"] != nil {
//                            //print(dict["error"] as! String)
//                            if  dict["error"] as! String == "Auth failed"{
//                                self.hanleAuthFail()
//                            }
//                            completion( dict["error"] as? String, nil)
//                        }else {
//                            completion( nil, dict)
//                        }
//                    } else {
//                        completion(nil, nil)
//                    }
//
//
//                }else {
//                    print(response.error?.localizedDescription ?? "")
//                    completion(response.error?.localizedDescription, nil)
//
//                }
//        }
//    }
//
//    
//    func fetchMessagesByItem(_id:String,completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
//        
//        let urlStr = baseUrlStr  + "messages/item/" + _id
//        var headers = THE_API.defaultHeaders
//        headers["Content-type"] = nil
//        
//        Alamofire.request(urlStr, method: .get, parameters: nil, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
//            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                print("Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                if response.error == nil {
//                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
//                        if dict["error"] != nil {
//                            //print(dict["error"] as! String)
//                            if  dict["error"] as! String == "Auth failed"{
//                                self.hanleAuthFail()
//                            }
//                            completion( dict["error"] as? String, nil)
//                        }else {
//                            completion( nil, dict)
//                        }
//                    } else {
//                        completion(nil, nil)
//                    }
//                    
//                    
//                }else {
//                    print(response.error?.localizedDescription ?? "")
//                    completion(response.error?.localizedDescription, nil)
//                    
//                }
//        }
//    }
    

    //MARK: helpers
    private func hanleAuthFail() {
        _ = DataManager.shared().deleteToken()
        _ = DataManager.shared().deleteUser()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setRootSigninViewController()
    }
        
    func signOut() {
        hanleAuthFail()
    }
        
    func getFullImageUrl(imageStr:String)->URL? {
        //update switch to remote storage 
        let str  = /*baseUrlStr +*/ imageStr
        return URL(string: str)
    }
    
    
//    var _id = ""
//    var itemId = ""
//    var itemOwnerId = ""
//    var otherUserId = ""
    
    
    func fetchChat(itemId:String, itemOwnerId:String, otherUserId:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "chats/chat"
        let params = [ "itemId" : itemId, "otherUserId" : otherUserId, "itemOwnerId" : itemOwnerId]
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }else {
                    print(response.error?.localizedDescription ?? "")
                    completion(response.error?.localizedDescription, nil)
                    
                }
        }
    }
    
    func fetchChatsForItem(itemId:String, itemOwnerId:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "chats"
        let params = [ "itemId" : itemId, "itemOwnerId" : itemOwnerId]
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }else {
                    print(response.error?.localizedDescription ?? "")
                    completion(response.error?.localizedDescription, nil)
                    
                }
        }
    }
    
    func createChat(itemId:String,itemOwnerId:String,otherUserId:String,completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "chats/chat/add"
        
        
        let params:[String : Any] = ["itemId" : itemId, "itemOwnerId" : itemOwnerId, "otherUserId" : otherUserId]
        
     
        Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            //print(dict["error"] as! String)
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }
                    
                    
                }else {
                    print(response.error?.localizedDescription ?? "")
                    completion(response.error?.localizedDescription, nil)
                    
                }
        }
    }
    
    
    
    
    
    func addMessageToChat(_id:String,userId:String, text:String ,completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "chats/chat/\(_id)"
       

        let params:[String : Any] = ["text" : text, "userId" : userId]
        
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding:  JSONEncoding.default, headers: THE_API.defaultHeaders)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                if response.error == nil {
                    if let dict = response.result.value as? Dictionary<String,AnyObject>{
                        if dict["error"] != nil {
                            //print(dict["error"] as! String)
                            if  dict["error"] as! String == "Auth failed"{
                                self.hanleAuthFail()
                            }
                            completion( dict["error"] as? String, nil)
                        }else {
                            completion( nil, dict)
                        }
                    } else {
                        completion(nil, nil)
                    }
                    
                    
                }else {
                    print(response.error?.localizedDescription ?? "")
                    completion(response.error?.localizedDescription, nil)
                    
                }
        }
    }
    
    
    
    

}
