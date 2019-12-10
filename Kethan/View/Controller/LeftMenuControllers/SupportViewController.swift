//
//  SupportViewController.swift
//  Kethan
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SupportViewController: BaseViewController {

    @IBOutlet weak var txtQuery: CustomTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Support", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        self.isNormalEditEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClickAction(_ sender: Any) {
        if let controller = self.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
            controller.isComeFromSupport = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
