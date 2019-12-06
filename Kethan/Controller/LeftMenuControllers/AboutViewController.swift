//
//  AboutViewController.swift
//  Kethan
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("About", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        self.isNormalEditEnabled = true
        // Do any additional setup after loading the view.
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
