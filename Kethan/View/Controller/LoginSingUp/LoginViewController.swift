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

class LoginViewController: BaseViewController, GIDSignInDelegate {
    
    @IBOutlet weak var imgAppName: UIImageView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var imgBg: UIImageView!
    
    @IBOutlet weak var constImageTop: CustomConstraint!
    @IBOutlet weak var constImageWidth: CustomConstraint!
    @IBOutlet weak var constImageHeight: CustomConstraint!
    
    @IBOutlet weak var constBGImageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    
    @IBOutlet weak var btnHidePwd: CustomButton!
    
    var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Animate the View
        self.imgTop.alpha = 0
        self.viewLogin.alpha = 0
        var height: Double = 0.0
        if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
            height = Double((self.view.bounds.size.height/2) - (self.imgTop.bounds.height/2) - (getCalculated(26.0)))
        } else {
            height = Double(getCalculated(198.0))
        }
        if isLoginViewAnimated == false {
            self.constImageTop.constant = CGFloat(-height)
            self.constImageWidth.constant = getCalculated(203.0)
            self.constImageHeight.constant = getCalculated(51.5)
            self.imgAppName.alpha = 1.0
            self.imgTop.alpha = 1.0
            self.viewLogin.alpha = 1.0
            self.view.layoutIfNeeded()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.constImageWidth.constant = getCalculated(171.0)
                    self.constImageHeight.constant = getCalculated(51.5)
                    self.view.layoutIfNeeded()
                }, completion: {(finish) in
                    UIView.animate(withDuration: 1.0, delay: 0.2, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
                        self.constImageTop.constant = CGFloat(-height)
                        self.view.layoutIfNeeded()
                    }) { (finish) in
                        UIView.animate(withDuration: 1.0) {
                            self.imgTop.alpha = 1.0
                            self.viewLogin.alpha = 1.0
                        }
                    }
                })
            }
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FacebookManager.logoutUser()
    }
    
    // MARK: - Button Action
    @IBAction func fbClickAction(_ sender: Any) {
        ProgressManager.show(withStatus: "", on: self.view)
         FacebookManager.loginToFacebookWith(controller: self) { (result: Any?, error: String?) in
         if error == nil {
         if let dict = result as? NSDictionary, let pictureDict = dict["picture"] as? NSDictionary, let dataDict = pictureDict["data"] as? NSDictionary {
         FacebookManager.logoutUser()
         if AppConstant.shared.loggedUser.accesstoken.trimmedString().count == 0 {
         self.loginVM.clearAllData()
         self.loginVM.email = dict["email"] as? String ?? ""
         self.loginVM.socialMediaID = dict["id"] as? String ?? ""
         self.loginVM.fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
         self.loginVM.loginType = "facebook"
         self.loginVM.profileURL = dataDict["url"] as? String ?? ""
         self.loginVM.validateSocialLogin(controller: self)
         }
         }
         } else {
         ProgressManager.showError(withStatus: error, on: self.view)
         }
         }
    }
    
    @IBAction func googleClickAction(_ sender: Any) {
         ProgressManager.show(withStatus: "", on: self.view)
         GIDSignIn.sharedInstance()?.delegate = self
         GIDSignIn.sharedInstance()?.signIn()
         GIDSignIn.sharedInstance()?.signOut()
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
        if let controller = self.instantiate(SignUpViewController.self, storyboard: STORYBOARD.signup) as? SignUpViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func signInClickAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.loginVM.clearAllData()
        self.loginVM.email = self.txtEmail.text!
        self.loginVM.password = self.txtPassword.text!
        self.loginVM.validateLogin(self)
    }
    
    @IBAction func forgotPassWordClickAction(_ sender: Any) {
        
        if let controller = self.instantiate(ForgotPwdViewController.self, storyboard: STORYBOARD.signup) as? ForgotPwdViewController {
            controller.isShowForgotScreen = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func hidePassWordClickAction(_ sender: Any) {
        self.txtPassword.isSecureTextEntry = (self.txtPassword.isSecureTextEntry == true) ?false:true
        self.btnHidePwd.setImage((self.txtPassword.isSecureTextEntry == true) ?UIImage(named: "hideEye"):UIImage(named: "unhideEye"), for: .normal)
    }
    
    // MARK: - Signin Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            ProgressManager.showError(withStatus: error.localizedDescription, on: self.view)
        } else {
            if AppConstant.shared.loggedUser.accesstoken.trimmedString().count == 0 {
                self.loginVM.clearAllData()
                self.loginVM.email = user.profile.email!
                self.loginVM.socialMediaID = user.userID!
                self.loginVM.fullName = "\(user.profile.givenName!) \(user.profile.familyName!)"
                self.loginVM.loginType = "google"
                self.loginVM.validateSocialLogin(controller: self)
            }
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
        ProgressManager.showError(withStatus: error.localizedDescription, on: self.view)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
