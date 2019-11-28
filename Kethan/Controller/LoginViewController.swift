//
//  LoginViewController.swift
//  Kethan
//
//  Created by Apple on 13/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var imgAppName: UIImageView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var imgBg: UIImageView!
    
    @IBOutlet weak var constImageTop: CustomConstraint!
    @IBOutlet weak var constBGImageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    
    var isViewAnimated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATIONS.googleUserUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.googleUserDataUpdate(notification:)), name: NSNotification.Name(rawValue: NOTIFICATIONS.googleUserUpdate), object: nil)
        /*self.imgAppName.transform = CGAffineTransform(translationX: 0, y: -150).concatenating(CGAffineTransform(scaleX: 0, y: 0))
         self.imgAppName.alpha = 0
         
         
         UIView.animate(withDuration: 5.0, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 10, options: [.curveEaseOut], animations: {
         self.imgAppName.transform = .identity
         self.imgAppName.alpha = 1
         
         }, completion: nil)*/
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgAppName.alpha = 0
        self.imgTop.alpha = 0
        self.viewLogin.alpha = 0
        
        if self.isViewAnimated == false {
            self.imgAppName.alpha = 1.0
            self.constImageTop.constant = getCalculated(54.0)
            self.imgTop.alpha = 1.0
            self.viewLogin.alpha = 1.0
            self.view.layoutIfNeeded()
        } else {
            UIView.animate(withDuration: 2.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.imgAppName.alpha = 1.0
            }, completion: {(finish) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.imgAppName.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2) // Scale your image
                }) { (finished) in
                    UIView.animate(withDuration: 1.0, animations: {
                        self.imgAppName.transform = CGAffineTransform.identity // undo in 1 seconds
                    }) { (finish) in
                        UIView.animate(withDuration: 1.0, animations: {
                            self.constImageTop.constant = getCalculated(54.0)
                            self.view.layoutIfNeeded()
                        }) { (finish) in
                            UIView.animate(withDuration: 1.0) {
                                self.imgTop.alpha = 1.0
                                self.viewLogin.alpha = 1.0
                            }
                        }
                    }
                }
            })
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func fbClickAction(_ sender: Any) {
        FacebookManager.loginToFacebookWith(controller: self) { (result: Any?, error: String?) in
            if error == nil {
                print("result==\(result)")
            } else {
                print("error==\(error)")
            }
        }
    }
    
    @IBAction func googleClickAction(_ sender: Any) {
        //GIDSignIn.sharedInstance()?.signIn()
        // GIDSignIn.sharedInstance()?.signOut()
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
    }
    
    @IBAction func signInClickAction(_ sender: Any) {
        self.navigateToHome(false, false)
    }
    
    @IBAction func forgotPassWordClickAction(_ sender: Any) {
    }
    
    @IBAction func hidePassWordClickAction(_ sender: Any) {
        self.txtPassword.isSecureTextEntry = (self.txtPassword.isSecureTextEntry == true) ?false:true
    }
    
    @objc func googleUserDataUpdate(notification: Notification) {
        
    }
    
    // MARK: - TextField Delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
