//
//  EditProfileVM.swift
//  Kethan
//
//  Created by Apple on 03/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class EditProfileVM: NSObject {
    var name: String = ""
    var contactNumber: String = ""
    var countryCode: String = ""
    var profession: String = ""
    var imgProfile: UIImage?
    
    var rootController: BaseViewController?
    
    override init() {
        
    }
    
    func clearAllData() {
        self.name = ""
        self.contactNumber = ""
        self.countryCode = ""
        self.profession = ""
    }
    
    func validateEditProfile(_ controller: BaseViewController) {
        self.rootController = controller
        if name.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.fullName, on: self.rootController!.view)
            return
        } else if self.contactNumber.count > 0 && self.contactNumber.count <= 9 {
            ProgressManager.showError(withStatus: ERRORS.validMobileNumber, on: self.rootController!.view)
            return
        }
        self.saveProfile()
    }
    
    func saveProfile() {
         ProgressManager.show(withStatus: "", on: self.rootController!.view)
        
        let dict: NSDictionary = [ENTITIES.name: self.name, ENTITIES.countryCode: self.countryCode, ENTITIES.contactNumber: self.contactNumber, ENTITIES.profession: self.profession]
        
        var imageDict: NSDictionary?
        if self.imgProfile != nil {
            imageDict  = saveImageInDocumentDict(image: self.imgProfile!, imageName: "photo", key: ENTITIES.userImage) as NSDictionary
        }
        
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.UpdateProfile, parameters: dict, multipart: (imageDict != nil) ?[imageDict!]:[], serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            FileManager.default.clearTmpDirectory()
            if error == nil {
                ProgressManager.dismiss()
                if let userDict = response!["user"] as? NSDictionary {
                    updateUserDetail(userDetail: userDict)
                    if let controller = self.rootController!.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
                        controller.isComeFrom = 2
                        self.rootController!.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    ProgressManager.showError(withStatus: MESSAGES.errorOccured, on: self.rootController!.view)
                }
                
            } else {
                ProgressManager.showError(withStatus: error, on: self.rootController!.view)
            }
        }
    }
}
