//
//  GoogleManager.swift
//  VocaWorks
//
//  Created by Mahesh on 26/09/18.
//  Copyright © 2018 Arkenea Technologies. All rights reserved.
//

import UIKit

import GoogleSignIn

typealias ResponseCompletion = (_ response: Any?, _ error: String?) -> Void

class GoogleManager: NSObject, GIDSignInDelegate {
    
    static var currentCompletion: ResponseCompletion?
    static let sharedInstance = GoogleManager()
    
    static func loginToGoogleWith(controller: UIViewController, completion: @escaping ResponseCompletion) {
        self.currentCompletion = completion
        GIDSignIn.sharedInstance()?.delegate = controller as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    static func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            GoogleManager.self.currentCompletion!(nil, error.localizedDescription)
        } else {
            let userData: NSDictionary = NSDictionary(dictionary: [
                "id": user.userID!,
                "first_name": user.profile.givenName!,
                "last_name": user.profile.familyName!,
                "email": user.profile.email!])
            GoogleManager.currentCompletion!(userData, nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        GoogleManager.currentCompletion!(nil, error.localizedDescription)
    }
}
