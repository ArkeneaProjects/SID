//
//  FacebookManager.swift
//  Kethan
//
//  Created by Pankaj on 26/09/18.
//  Copyright © 2019 Arkenea Technologies. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class FacebookManager: NSObject {
    static func loginToFacebookWith(controller: UIViewController, completion: @escaping ResponseCompletion) {
        LoginManager().logIn(permissions: ["public_profile", "email"], viewController: controller) { (result) in
            switch result {
            case .cancelled:
                print("LOGIN REQUEST CANCELED")
                 completion(nil, "You have cancelled the login. Please try again.")
            case .failed(let e):
                completion(nil, e.localizedDescription)
                print("REQ FAILED HERE IS ERROR: ", e.localizedDescription)
            case .success(granted: _, declined: _, token: let token):
                print("GOT THE TOKEN: ", token.tokenString)
                
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: ["fields":"email, first_name, middle_name, last_name, gender, picture.type(large)"], tokenString: token.tokenString, version: nil, httpMethod: .get)
                graphRequest.start { (connection: GraphRequestConnection?, result: Any?, error: Error?) in
                    if(error == nil) {
                        if let dictResponse = result as? NSDictionary {
                            completion(dictResponse, nil)
                        }
                    } else {
                        completion(nil, error?.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    static func logoutUser() {
        LoginManager().logOut()
    }
}
