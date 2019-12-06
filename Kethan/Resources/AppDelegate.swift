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
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, GIDSignInDelegate {
   
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
        GIDSignIn.sharedInstance()?.delegate = self

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let base = BaseViewController()
        base.navigateToHome(true, true)
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
    
    // MARK: Google Sign-In Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            let userData: NSDictionary = NSDictionary(dictionary: [
             "id": user.userID!,
             "first_name": user.profile.givenName!,
             "last_name": user.profile.familyName!,
             "email": user.profile.email!])
             print(userData)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
    
}
