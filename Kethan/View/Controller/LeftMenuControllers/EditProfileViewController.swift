//
//  EditProfileViewController.swift
//  Kethan
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, GalleryManagerDelegate {

    @IBOutlet weak var imgProfile: UIImageView!
    var imagePicker: GalleryManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Profile", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)
        
        // Profile Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileClickAction(_:)))
        self.imgProfile.addGestureRecognizer(tapGesture)
        self.imgProfile.isUserInteractionEnabled = true
    }
    
    @IBAction func editImageClickAction(_ sender: Any) {
        self.showActionSheet(headerTitle: "Choose Image From", cameraTitle: "Camera", galleryTitle: "Gallery", galleryCompletion: {
            self.imagePicker.present(croppingStyle: .circular, isCrop: true, isCamera: false)
        }) {
            self.imagePicker.present(croppingStyle: .circular, isCrop: true, isCamera: true)
        }
    }
    
    @objc func profileClickAction(_ sender: Any) {
        self.openGalleryList(indexpath: IndexPath(row: 0, section: 0), imgNameArr: NSMutableArray(array: ["profilePic"]), sourceView: self.imgProfile)
    }
    
    func didSelect(image: UIImage?) {
        print(image)
        self.imgProfile.image = image
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
