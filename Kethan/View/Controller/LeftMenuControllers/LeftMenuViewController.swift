//
//  LeftMenuViewController.swift
//  Kethan
//
//  Created by Apple on 13/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblPhone: CustomLabel!
    @IBOutlet weak var lblEmail: CustomLabel!
    @IBOutlet weak var lblUserName: CustomLabel!
    
    @IBOutlet weak var imgProfile: UIImageView! 
    @IBOutlet weak var imgPhone: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
//            if AppConstant.shared.loggedUser.isSocialMediaUser != "0" {
//                STATICDATA.arrLeftItems.remove(at: 1)
//                STATICDATA.arrLeftItems.remove(at: 1)
//            }
            self.tblView.registerNibWithIdentifier([IDENTIFIERS.LeftMenuTableViewCell])
            self.tblView.reloadData()
            
            // Profile Image
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileClickAction(_:)))
            self.imgProfile.addGestureRecognizer(tapGesture)
            self.imgProfile.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.displayData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    func displayData() {
           self.imgProfile.sd_setImage(with: URL(string: AppConstant.shared.loggedUser.userImage), placeholderImage: UIImage(named: "default-user"), options: .continueInBackground, context: nil)
           self.lblUserName.text = AppConstant.shared.loggedUser.name
           self.lblEmail.text = AppConstant.shared.loggedUser.email
           self.lblPhone.text = "\(AppConstant.shared.loggedUser.country_code) \(AppConstant.shared.loggedUser.contactNumber)"
       }
    
    // MARK: - Button Action
    @IBAction func editProfileAction(_ sender: Any) {
       /* if let tabbarController = AppDelegate.delegate()!.window!.rootViewController as? UITabBarController {
            if let frontNavigationController = tabbarController.viewControllers![1] as? UINavigationController {
                let storyBoard = UIStoryboard(name: STORYBOARD.signup, bundle: Bundle.main)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                let frontViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.revealViewController()?.setFront(frontViewController!, animated: false)
                self.revealViewController()?.setFrontViewPosition(.left, animated: false)
                frontNavigationController.pushViewController(loginVC!, animated: true)
            }
        } */
    }
    
    @objc func profileClickAction(_ sender: Any) {
        self.openGalleryList(indexpath: IndexPath(row: 0, section: 0), imgNameArr: NSMutableArray(array: [AppConstant.shared.loggedUser.userImage]), sourceView: self.imgProfile)
    }
    
    func cellClickAction(_ identifier: String, _ screen: String) {
        
        if let tabbarController = AppDelegate.delegate()!.window!.rootViewController as? UITabBarController {
            if let frontNavigationController = tabbarController.viewControllers![1] as? UINavigationController {
                
                let storyBoard = UIStoryboard(name: STORYBOARD.main, bundle: Bundle.main)
                var baseController: BaseViewController?
                
                if identifier == "ProfileViewController" {
                    if let controller = self.instantiate(ProfileViewController.self, storyboard: STORYBOARD.leftMenu) as? ProfileViewController {
                        baseController = controller
                    }
                } else if identifier == "SignUpUserGuideViewController" {
                    if let controller = self.instantiate(SignUpUserGuideViewController.self, storyboard: STORYBOARD.signup) as? SignUpUserGuideViewController {
                        controller.isShowNavBar = true
                        baseController = controller
                    }
                } else if identifier == "ForgotPwdViewController" {
                    if let controller = self.instantiate(ForgotPwdViewController.self, storyboard: STORYBOARD.signup) as? ForgotPwdViewController {
                        controller.isShowForgotScreen = false
                        baseController = controller
                    }
                } else if identifier == "ChangePwdViewController" {
                    if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
                        controller.isComeFrom = 0
                        baseController = controller
                    }
                } else if identifier == "SubScriptionViewController" {
                    if let controller = self.instantiate(SubScriptionViewController.self, storyboard: STORYBOARD.signup) as? SubScriptionViewController {
                        controller.isComeFromLogin = false
                        baseController = controller
                    }
                } else if identifier == "SupportViewController" {
                    if let controller = self.instantiate(SupportViewController.self, storyboard: STORYBOARD.leftMenu) as? SupportViewController {
                        baseController = controller
                    }
                } else if identifier == "TermsConditionViewController" {
                    if let controller = self.instantiate(TermsConditionViewController.self, storyboard: STORYBOARD.leftMenu) as? TermsConditionViewController {
                        controller.isPage = (screen == "Terms") ?0:(screen == "Privacy") ?1:(screen == "FAQ") ?2:3
                        controller.urlString = "https://www.google.com/"
                        baseController = controller
                    }
                } else {
                    baseController = storyBoard.instantiateViewController(withIdentifier: "\(identifier)") as? BaseViewController ?? BaseViewController()
                }
                
//                let navController = self.revealViewController().frontViewController as? UINavigationController
//                if let topController = navController!.topViewController as? HomeViewController {
//                    print("sucess")
//                    self.revealViewController()?.setFrontViewPosition(.left, animated: false)
//                    frontNavigationController.pushViewController(baseController!, animated: true)
//                }
                
                if let frontViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    //self.revealViewController()?.setFront(frontViewController, animated: false)
                    self.revealViewController()?.setFrontViewPosition(.left, animated: false)
                    frontNavigationController.pushViewController(baseController!, animated: true)
                }
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        if let displayName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            self.showAlert(title: "", message: "Are you sure you want to logout from \(displayName)", yesTitle: YESNO.yes, noTitle: YESNO.no, yesCompletion: {
                let logoutVM = LogoutVM()
                logoutVM.logoutFromSystem(controller: self)
            }, noCompletion: nil)
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCalculated(40.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppConstant.shared.loggedUser.isSocialMediaUser != "0") ?STATICDATA.arrLeftItemsWithoutEmail.count:STATICDATA.arrLeftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.LeftMenuTableViewCell) as? LeftMenuTableViewCell {
            let arr = (AppConstant.shared.loggedUser.isSocialMediaUser != "0") ?STATICDATA.arrLeftItemsWithoutEmail[indexPath.row]:STATICDATA.arrLeftItems[indexPath.row]
            cell.imgProfile.image = UIImage(named: arr["image"]!)
            cell.lblText.text = arr["text"]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let arr = (AppConstant.shared.loggedUser.isSocialMediaUser != "0") ?STATICDATA.arrLeftItemsWithoutEmail[indexPath.row]:STATICDATA.arrLeftItems[indexPath.row]
        let cellValue = arr["text"]
        
        if cellValue == "Profile" {
            self.cellClickAction("ProfileViewController", "Profile")
        } else if cellValue == "Change Email " {
            self.cellClickAction("ForgotPwdViewController", "Email")
        } else if cellValue == "Change Password " {
            self.cellClickAction("ChangePwdViewController", "Password")
        } else if cellValue == "Upgrade Subscription" {
            self.cellClickAction("SubScriptionViewController", "SubScription")
        } else if cellValue == "User Walkthrough" {
            self.cellClickAction("SignUpUserGuideViewController", "Guide")
        } else if cellValue == "FAQs" {
            self.cellClickAction("TermsConditionViewController", "FAQ")
        } else if cellValue == "Terms of Service" {
            self.cellClickAction("TermsConditionViewController", "Terms")
        } else if cellValue == "Privacy Policy" {
            self.cellClickAction("TermsConditionViewController", "Privacy")
        } else if cellValue == "About the App" {
            self.cellClickAction("TermsConditionViewController", "About")
        } else if cellValue == "Support" {
            self.cellClickAction("SupportViewController", "Support")
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
