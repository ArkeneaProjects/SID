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
    
    var isComeFromLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Change Password", withLeftButtonType: (isComeFromLogin == true) ?.buttonTypeNil:.buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
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
