//
//  VerifyOTPViewController.swift
//  Kethan
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SVPinView

class VerifyOTPViewController: BaseViewController {
    
    @IBOutlet weak var viewPin: SVPinView!
    
    var enterEmail = ""
    var otp = ""
    
    let signupVM = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Verify Email", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        viewPin.shouldSecureText = false
        viewPin.style = .box
        viewPin.font = APP_FONT.regularFont(withSize: 23.5)
        viewPin.keyboardType = .phonePad
        viewPin.pinInputAccessoryView = UIView()
        viewPin.becomeFirstResponderAtIndex = 0
        viewPin.pinInputAccessoryView = UIView()
        viewPin.becomeFirstResponderAtIndex = 0
        viewPin.activeBorderLineThickness = getCalculated(1.5)
        viewPin.didFinishCallback = didFinishEnteringPin(pin:)
        viewPin.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            self.otp = pin
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func didFinishEnteringPin(pin: String) {
        print("Sucess ==\(pin)")
        self.view.endEditing(true)
    }
    
    @IBAction func reSendOTPClickAction(_ sender: Any) {
        self.view.endEditing(true)
      /*  self.viewPin.clearPin()
        ProgressManager.show(withStatus: "", on: self.view)
        self.signupVM.callResendOTP {
            if self.signupVM.errorOTP == "" {
                ProgressManager.showSuccess(withStatus: "OTP sucessfully send on register mailid", on: self.view)
            } else {
                ProgressManager.showError(withStatus: self.signupVM.errorOTP, on: self.view)
            }
        } */
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
        self.view.endEditing(true)
        
      /*  signupVM.otp = self.otp
        signupVM.email = self.enterEmail
        switch signupVM.validateOTP() {
        case .Valid:
            ProgressManager.show(withStatus: "", on: self.view)
            signupVM.callSignUpOTPAPI {
                if self.signupVM.errorOTP == "" {
                    if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
                        controller.isComeFrom = 2
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    ProgressManager.showError(withStatus: self.signupVM.errorOTP, on: self.view)
                }
            }
        case .InValid(let error):
            ProgressManager.showError(withStatus: error, on: self.view)
        } */
        
        if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
            controller.isComeFrom = 2
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func referralClickAction(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
