//
//  FeaturedViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Home", withLeftButtonType: .buttonTypeMenu, withRightButtonType: .buttonTypeCredit)
       
    }
    
    override func leftButtonAction() {
        self.revealViewController()?.revealToggle(self.navBar.btnLeft)
    }

    @IBAction func buttonAction(_ sender: Any) {
     
        /*let storyBoard = UIStoryboard(name: STORYBOARD.main, bundle: Bundle.main)
        let frontViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(frontViewController!, animated: true)*/
      
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
