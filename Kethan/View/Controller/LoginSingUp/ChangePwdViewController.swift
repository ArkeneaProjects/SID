//
//  ChangePwdViewController.swift
//  Kethan
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ChangePwdViewController: BaseViewController {
    
    @IBOutlet weak var txtConfirmPwd: CustomTextField!
    @IBOutlet weak var txtPwd: CustomTextField!
    @IBOutlet weak var txtOldPwd: CustomTextField!
    
    var isComeFrom =  0  // 0 for ChangePassword, 1 for forgot, 2 for signup
    
    @IBOutlet weak var lblOldPwd: CustomLabel!
    @IBOutlet weak var lblNewPwd: CustomLabel!
    @IBOutlet weak var lblConfirmPwd: CustomLabel!
    
    @IBOutlet weak var btnHideOldPwd: CustomButton!
    @IBOutlet weak var btnHideNewPwd: CustomButton!
    @IBOutlet weak var btnHideConfirmPwd: CustomButton!
    
    @IBOutlet weak var constOldPwdHeight: CustomConstraint!
    @IBOutlet weak var constNewPwdTop: CustomConstraint!
    
    let changePwdVM = ChanagePasswordVM()
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Change Password", withLeftButtonType: (isComeFrom == 0) ?.buttonTypeBack:.buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.constOldPwdHeight.constant = (isComeFrom != 0) ?0:getCalculated(66.0)
        self.constNewPwdTop.constant = (isComeFrom != 0) ?0:getCalculated(24.0)
        
        self.lblNewPwd.text = (isComeFrom == 0) ?"Enter Old Password":""
        self.lblNewPwd.text = (isComeFrom == 0) ?"Enter New Password":"Enter New Password"
        self.lblConfirmPwd.text = (isComeFrom == 0) ?"Confirm New Password":"Confirm New Password"
        
        self.txtOldPwd.placeholder = (isComeFrom == 0) ?"Enter Old Password":""
        self.txtPwd.placeholder = (isComeFrom == 0) ?"Enter New Password":"Enter New Password"
        self.txtConfirmPwd.placeholder = (isComeFrom == 0) ?"Confirm New Password":"Confirm New Password"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func hideOldPwdClickAction(_ sender: Any) {
        self.txtOldPwd.isSecureTextEntry = (self.txtOldPwd.isSecureTextEntry == true) ?false:true
        self.btnHideOldPwd.setImage((self.txtOldPwd.isSecureTextEntry == true) ?UIImage(named: "hideEye"):UIImage(named: "unhideEye"), for: .normal)
    }
    
    @IBAction func hidePwdClickAction(_ sender: Any) {
        self.txtPwd.isSecureTextEntry = (self.txtPwd.isSecureTextEntry == true) ?false:true
        self.btnHideNewPwd.setImage((self.txtPwd.isSecureTextEntry == true) ?UIImage(named: "hideEye"):UIImage(named: "unhideEye"), for: .normal)
    }
    
    @IBAction func hideConfirmPwdClickAction(_ sender: Any) {
        self.txtConfirmPwd.isSecureTextEntry = (self.txtConfirmPwd.isSecureTextEntry == true) ?false:true
        self.btnHideConfirmPwd.setImage((self.txtConfirmPwd.isSecureTextEntry == true) ?UIImage(named: "hideEye"):UIImage(named: "unhideEye"), for: .normal)
    }
    
    @IBAction func DoneClickAction(_ sender: Any) {
        self.view.endEditing(true)
        self.changePwdVM.clearAll()
        self.changePwdVM.oldPwd = self.txtOldPwd.text!
        self.changePwdVM.newPwd = self.txtPwd.text!
        self.changePwdVM.confirmPwd = self.txtConfirmPwd.text!
        self.changePwdVM.email = email
        self.changePwdVM.iscommingFrom = self.isComeFrom
        self.changePwdVM.validateChangePwd(controller: self)
        
        //        if let controller = self.instantiate(SignUpUserGuideViewController.self, storyboard: STORYBOARD.signup) as? SignUpUserGuideViewController {
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtOldPwd {
            self.txtPwd.becomeFirstResponder()
        } else if textField == self.txtPwd {
            self.txtConfirmPwd.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
