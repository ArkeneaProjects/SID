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
    
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    var isComeFromSupport: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkbox.onAnimationType = .stroke
        self.checkbox.offAnimationType = .stroke
        self.checkbox.animationDuration = 0.9
        
        self.lblMsg.text = (self.isComeFromSupport == true) ?"Your support query has been submitted" :"Your details have been sent     for verification. We'll let you know once it's verified. "
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
