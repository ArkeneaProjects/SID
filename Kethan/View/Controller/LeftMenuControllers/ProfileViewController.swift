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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Profile", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeEdit)
        // Do any additional setup after loading the view.
        
        // Profile Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileClickAction(_:)))
        self.imgProfile.addGestureRecognizer(tapGesture)
        self.imgProfile.isUserInteractionEnabled = true
    }
    
    // MARK: - Button Action
    override func rightButtonAction() {
        if let controller = self.instantiate(EditProfileViewController.self, storyboard: STORYBOARD.leftMenu) as? EditProfileViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func profileClickAction(_ sender: Any) {
        self.openGalleryList(indexpath: IndexPath(row: 0, section: 0), imgNameArr: NSMutableArray(array: ["profilePic"]), sourceView: self.imgProfile)
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
