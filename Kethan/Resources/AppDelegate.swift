//
//  AppDelegate.swift
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var tabBarController: BaseTabBarViewController!
    var tabBarDelegate: BaseTabBarControllerDelegate = BaseTabBarControllerDelegate()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       UNUserNotificationCenter.current().delegate = self
        
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = false
        
        //Custom Logger
        CustomLogger.sharedInstance.setupLogger(true)
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = KEYS.googleKey
        GMSPlacesClient.provideAPIKey(KEYS.GooglePlacesAPIKey)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        //Notification Enable
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {

            // If your app wasn’t running and the user launches it by tapping the push notification, the push notification is passed to your app in the launchOptions
            if let aps = notification["aps"] as? [String: AnyObject] {
                
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
        }

        registerForPushNotifications()
        
        let base = BaseViewController()
        if let dictionary = getUserDefaultsForKey(key: UserDefaultsKeys.LoggedUser) as? NSDictionary {
            updateUserDetail(userDetail: dictionary)
            base.navigateToHome((AppConstant.shared.loggedUser.accesstoken.trimmedString().count > 0) ?false:true, true)
        } else {
            base.navigateToHome(true, true)
            
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // return ApplicationDelegate.shared.application(app, open: url, options: options)
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        if ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation) == true {
            return true
        } else {
            return GIDSignIn.sharedInstance().handle(url)
        }
    }
    
    class func delegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
}
