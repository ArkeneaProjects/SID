//
//  AppDelegate.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
// com.YupEasy1

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
   
    var tabBarController: BaseTabBarViewController!
    var tabBarDelegate: BaseTabBarControllerDelegate = BaseTabBarControllerDelegate()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /* let storyBoard = UIStoryboard(name: STORYBOARD.main, bundle: Bundle.main)
         self.window = UIWindow(frame: UIScreen.main.bounds)
         let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
         if let window = window {
         window.rootViewController = yourVc
         }
         self.window?.makeKeyAndVisible()*/
        
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = false
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = KEYS.googleKey

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
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
