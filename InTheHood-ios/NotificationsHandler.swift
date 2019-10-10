//
//  NotificationsHandler.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 09/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import UserNotifications

final class NotificationsHandler: NSObject,UNUserNotificationCenterDelegate {
    

    private static var sharedNetworkManager: NotificationsHandler = {
        let networkManager = NotificationsHandler()
        return networkManager
    }()
    
    private override init() {
      
    }
    
    class func shared() -> NotificationsHandler {
        return sharedNetworkManager
    }
    
    //MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("newMessage"), object: nil)
        
    }
    
    
  
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
    }
    
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?){
        
    }

    


}
