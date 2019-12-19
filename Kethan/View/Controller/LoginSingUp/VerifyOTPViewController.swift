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
    
    @IBOutlet weak var pinView: SVPinView!
    
    var enterEmail = ""
    var otp = ""
    
    let signupVM = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Verify Email", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        pinView.shouldSecureText = false
        pinView.style = .box
        pinView.font = APP_FONT.regularFont(withSize: 23.5)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = UIView()
        pinView.becomeFirstResponderAtIndex = 0
        pinView.pinInputAccessoryView = UIView()
        pinView.becomeFirstResponderAtIndex = 0
        pinView.activeBorderLineThickness = getCalculated(1.5)
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
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
        self.pinView.clearPin()
        self.signupVM.clearAllData()
        signupVM.email = self.enterEmail
        self.signupVM.signupResendOTP(controller: self)
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.signupVM.clearAllData()
        self.signupVM.otp = self.otp
        self.signupVM.email = self.enterEmail
        self.signupVM.validateOTP(controller: self)
        
//        if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
//            controller.isComeFrom = 2
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
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
