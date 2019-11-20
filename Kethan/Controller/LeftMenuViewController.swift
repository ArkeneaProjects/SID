//
//  LeftMenuViewController.swift
//  Kethan
//
//  Created by Apple on 13/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        if let tabbarController = AppDelegate.delegate()!.window!.rootViewController as? UITabBarController {
            if let frontNavigationController = tabbarController.viewControllers![1] as? UINavigationController {
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                let frontViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.revealViewController()?.setFront(frontViewController!, animated: false)
                self.revealViewController()?.setFrontViewPosition(.left, animated: false)
                frontNavigationController.pushViewController(loginVC!, animated: true)
            }
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
