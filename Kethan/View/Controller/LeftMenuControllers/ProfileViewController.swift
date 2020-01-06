//
//  ProfileViewController.swift
//  Kethan
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: CustomLabel!
    @IBOutlet weak var lblEmail: CustomLabel!
    @IBOutlet weak var lblNumber: CustomLabel!
    @IBOutlet weak var lblCreditPoints: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Profile", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeEdit)
        // Do any additional setup after loading the view.
        self.navBar.btnRightEdit.contentHorizontalAlignment = .right
        // Profile Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileClickAction(_:)))
        self.imgProfile.addGestureRecognizer(tapGesture)
        self.imgProfile.isUserInteractionEnabled = true
        
        self.displayData()
    }
    
    func displayData() {
        self.imgProfile.sd_setImage(with: URL(string: AppConstant.shared.loggedUser.userImage), placeholderImage: UIImage(named: "default-user"), options: .continueInBackground, context: nil)
        self.lblName.text = AppConstant.shared.loggedUser.name
        self.lblEmail.text = AppConstant.shared.loggedUser.email
        self.lblNumber.text = "\(AppConstant.shared.loggedUser.country_code) \(AppConstant.shared.loggedUser.contactNumber)"
        self.lblCreditPoints.text = "\(AppConstant.shared.loggedUser.creditPoint) Credits"
    }
    
    // MARK: - Button Action
    override func rightButtonAction() {
        if let controller = self.instantiate(EditProfileViewController.self, storyboard: STORYBOARD.leftMenu) as? EditProfileViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func profileClickAction(_ sender: Any) {
        self.openGalleryList(indexpath: IndexPath(row: 0, section: 0), imgNameArr: NSMutableArray(array: [AppConstant.shared.loggedUser.userImage]), sourceView: self.imgProfile)
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
