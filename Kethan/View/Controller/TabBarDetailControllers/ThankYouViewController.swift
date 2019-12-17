//
//  ThankYouViewController.swift
//  Kethan
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ThankYouViewController: BaseViewController {

    @IBOutlet weak var lblMsg: CustomLabel!
    
    @IBOutlet weak var lblThankYou: CustomLabel!

    @IBOutlet weak var checkbox: BEMCheckBox!
    
    var isComeFrom = 0 // 0 for support, 1 for add details, 2 for edit profile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkbox.onAnimationType = .stroke
        self.checkbox.offAnimationType = .stroke
        self.checkbox.animationDuration = 0.9
        
        self.lblThankYou.text = (self.isComeFrom == 2) ?"Done":"Thank you!"
        self.lblMsg.text = (self.isComeFrom == 0) ?"Your support query has been submitted" :(self.isComeFrom == 1) ?"Your details have been sent for verification. We'll let you know once it's verified.":"The changes made have been saved against your profile."
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkbox.setOn(true, animated: true)
        }
    }
    
    // MARK: - Button Click Action
    @IBAction func homeClickAction(_ sender: CustomButton) {
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
