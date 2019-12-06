//
//  ForgotPwdViewController.swift
//  Kethan
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SVPinView

class ForgotPwdViewController: BaseViewController {
    
    @IBOutlet weak var constSpacerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnChangeEmail: CustomButton!
    @IBOutlet weak var btnSend: CustomButton!
    
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var lblNewEmail: CustomLabel!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblOTPMsg: CustomLabel!
    
    var isShowForgotScreen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle((self.isShowForgotScreen == true) ?"Forgot Password":"Change Email", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        self.constSpacerViewHeight.constant = self.view.frame.size.height - getCalculated(142.0)
        
        self.lblNewEmail.text = (self.isShowForgotScreen == true) ?"Enter email address":"Enter new email address"
        self.lblOTPMsg.text = (self.isShowForgotScreen == true) ?"Forgot your password? Don't worry we got you covered. We've sent an OTP to your registered email address Enter the OTP below to proceed further":"We've sent you an OTP on the above email address. Enter the OTP and verify to change your email address"
        self.btnChangeEmail.setTitle((self.isShowForgotScreen == true) ?"Reset Password":"Change Email", for: .normal)
        self.txtEmail.becomeFirstResponder()
    }
    
    // MARK: - Button Click Action
    @IBAction func sendActionClick(_ sender: Any) {
        self.view.endEditing(true)
        
        pinView.shouldSecureText = false
        pinView.style = .box
        pinView.font = UIFont(name: "HelveticaNeue", size: getCalculated(23.5))!
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = UIView()
        pinView.becomeFirstResponderAtIndex = 0
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
        
        UIView.animate(withDuration: 0.3) {
            self.btnSend.alpha = 0
            self.constSpacerViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func changeEmailActionClick(_ sender: Any) {
        if self.isShowForgotScreen == false {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
                controller.isComeFromLogin = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - Button Action
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func didFinishEnteringPin(pin: String) {
        print("Sucess ==\(pin)")
    }
    
    @IBAction func reSendOTPClickAction(_ sender: Any) {
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
