//
//  AppDelegate+PushNotifications.swift
//  Kethan
//
//  Created by Apple on 27/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else {
                    print("Please enable \"Notifications\" from App Settings.")
                    self?.showPermissionAlert()
                    return
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Received notification :: \(userInfo.description)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification With Completion :: \(userInfo.description)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Title: \(notification.request.content.userInfo)")

        completionHandler([.alert, .badge, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Message Main: \(response.notification.request.content.userInfo)")
        if let apsDict = response.notification.request.content.userInfo as? NSDictionary {
            self.notificationDict(apsDict)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let dictionary = getUserDefaultsForKey(key: UserDefaultsKeys.LoggedUser) as? NSDictionary {
            let loggedUser = User(dictionary: dictionary)
            AppConstant.shared.loggedUser = loggedUser
        }
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        device_token = tokenParts.joined()
        print("Device Token: \(device_token)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoAppSettings() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
    
    func notificationDict(_ dict: NSDictionary) {
        let notificationType = dict.value(forKey: "type") as? String ?? ""
        if let rootController = getTopViewController() {
            if notificationType == NOTIFICATIONS.verification || notificationType == NOTIFICATIONS.referral {
                if let controller = rootController.instantiate(PurchesViewController.self, storyboard: STORYBOARD.main) as? PurchesViewController {
                    controller.isCameFromNotification = true
                    rootController.navigationController?.pushViewController(controller, animated: true)
                }
            } else if notificationType == NOTIFICATIONS.subscription {
                if let controller = rootController.instantiate(SubScriptionViewController.self, storyboard: STORYBOARD.signup) as? SubScriptionViewController {
                    controller.isComeFromLogin = false
                    rootController.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
}
