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
            self.tblView.registerNibWithIdentifier([IDENTIFIERS.LeftMenuTableViewCell])
//                   self.tblView.rowHeight = UITableView.automaticDimension
//                   self.tblView.estimatedRowHeight = getCalculated(40.0)
//                   self.tblView.tableFooterView = UIView()
            self.tblView.reloadData()
        }
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
    
    // MARK: - Button Action
    @IBAction func editProfileAction(_ sender: Any) {
        if let tabbarController = AppDelegate.delegate()!.window!.rootViewController as? UITabBarController {
                   if let frontNavigationController = tabbarController.viewControllers![1] as? UINavigationController {
                       let storyBoard = UIStoryboard(name: STORYBOARD.main, bundle: Bundle.main)
                       let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                       let frontViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                       self.revealViewController()?.setFront(frontViewController!, animated: false)
                       self.revealViewController()?.setFrontViewPosition(.left, animated: false)
                       frontNavigationController.pushViewController(loginVC!, animated: true)
                   }
               }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        self.showAlert(title: "", message: "Are you sure you want to logout from Kethan", yesTitle: YESNO.yes, noTitle: YESNO.no, yesCompletion: {
            self.logoutFromApp()
        }, noCompletion: nil)
    }
   
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCalculated(40.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STATICDATA.arrLeftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.LeftMenuTableViewCell) as? LeftMenuTableViewCell {

            let arr = STATICDATA.arrLeftItems[indexPath.row]
            cell.imgProfile.image = UIImage(named: arr["image"]!)
            cell.lblText.text = arr["text"]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
