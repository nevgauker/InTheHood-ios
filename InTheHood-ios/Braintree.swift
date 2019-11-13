//
//  Braintree.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 09/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import BraintreeDropIn
import Braintree

final class Braintree: NSObject {
    
       private static var sharedPaymentManager: Braintree = {
           let paymentManager = Braintree()
           return paymentManager
       }()
       
       private override init() {
           
       }
       class func shared() -> Braintree {
           return sharedPaymentManager
       }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String, vc:UIViewController) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        vc.present(dropIn!, animated: true, completion: nil)
    }
    
    func fetchExistingPaymentMethod(clientToken: String) {
        BTDropInResult.fetch(forAuthorization: clientToken, handler: { (result, error) in
            if (error != nil) {
                print("ERROR")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
        })
    }
       

}
