//
//  NetworkingManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 02/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//


import Alamofire

class API: NSObject {
    let baseURLDEV = "http://localhost:3004/"
    let baseURLPROD = ""
    let defaultHeaders:[String: String] = [String :  String]()
}


class NetworkingManager: NSObject {
    
    var THE_API:API!
    var baseUrlStr: String!
    
    var categories:[String]?
    
    
    private static var sharedNetworkManager: NetworkingManager = {
        let THE_API  = API()
        let networkManager = NetworkingManager(api: THE_API)
        return networkManager
    }()
    
    private init(api: API) {
        self.THE_API = api
        baseUrlStr =  THE_API.baseURLPROD
        if Utils.IsDevelopment() {
            baseUrlStr = THE_API.baseURLDEV
        }
    }
    
    class func shared() -> NetworkingManager {
        return sharedNetworkManager
    }
    
    
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
                            self.categories = arr
                        }
                    }
                }
                else {
                    print(response.error?.localizedDescription ?? "")
                }
                
              
                
                
                
        }
        
    
            

        
        
        
        

    }
    
    
    
    func signin(email:String, password:String, completion: @escaping (_ error:String?, _ data:[String : Any]?) -> ()) {
        
        let urlStr = baseUrlStr  + "user/signin"
        let params = ["email": email, "password": password]
        
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
                        
                        if  dict["error"] == nil {
                            completion(nil, dict)

                        }else {
                            completion(dict["error"] as? String, nil)
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
        let headers = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
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
                            if dict["message"] as! String == "Auth successful" {
                                completion(nil, dict)
                            }else {
                                completion(dict["message"] as? String,nil)
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

       
                
                
        


}
