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
    
    var isComeFromLogin: Bool = false
    
    @IBOutlet weak var lblOldPwd: CustomLabel!
    @IBOutlet weak var lblNewPwd: CustomLabel!
    @IBOutlet weak var lblConfirmPwd: CustomLabel!
    
    @IBOutlet weak var constOldPwdHeight: CustomConstraint!
    @IBOutlet weak var constNewPwdTop: CustomConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Change Password", withLeftButtonType: (isComeFromLogin == true) ?.buttonTypeNil:.buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        self.constOldPwdHeight.constant = (isComeFromLogin == true) ?0:getCalculated(66.0)
        self.constNewPwdTop.constant = (isComeFromLogin == true) ?0:getCalculated(24.0)

        self.lblNewPwd.text = (isComeFromLogin == true) ?"Enter Old Password":""
        self.lblNewPwd.text = (isComeFromLogin == true) ?"Password":"Enter New Password"
        self.lblConfirmPwd.text = (isComeFromLogin == true) ?"Confirm Password":"Confirm New Password"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func hideOldPwdClickAction(_ sender: Any) {
        self.txtOldPwd.isSecureTextEntry = (self.txtOldPwd.isSecureTextEntry == true) ?false:true
    }
    
    @IBAction func hidePwdClickAction(_ sender: Any) {
           self.txtPwd.isSecureTextEntry = (self.txtPwd.isSecureTextEntry == true) ?false:true
       }
    @IBAction func hideConfirmPwdClickAction(_ sender: Any) {
        self.txtConfirmPwd.isSecureTextEntry = (self.txtConfirmPwd.isSecureTextEntry == true) ?false:true
    }
    
    @IBAction func DoneClickAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
