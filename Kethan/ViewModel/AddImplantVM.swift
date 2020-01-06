//
//  AddImplantVM.swift
//  Kethan
//
//  Created by Ashwini on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class AddImplantVM: NSObject {
    var rootViewController: BaseViewController?
    var implantObj = SearchResult()
    
    func uploadImplant(_ controller: BaseViewController) {
        self.rootViewController = controller
        if implantObj.objectName.count < 1 {
            ProgressManager.showError(withStatus: ERRORS.EmptyBrandName, on: self.rootViewController!.view)
            return
        } else if implantObj.implantManufacture.count < 1 {
            ProgressManager.showError(withStatus: ERRORS.EmptyManufacturer, on: self.rootViewController!.view)
            return
        } else if implantObj.removImplant.count < 1 {
            ProgressManager.showError(withStatus: ERRORS.EmptyRemovalProcess, on: self.rootViewController!.view)
            return
        } else if implantObj.implantImage.selectedImage == nil {
            ProgressManager.showError(withStatus: ERRORS.EmptyImage, on: self.rootViewController!.view)
            return
        } else {
            ProgressManager.show(withStatus: "Uploading Implant...", on: self.rootViewController!.view)
        
            let parameters: NSDictionary =  [ "labelName": self.implantObj.objectName,
                                            "implantManufacture": self.implantObj.implantManufacture,
                                            "imageWidth": self.implantObj.implantImage.imageWidth,
                                            "imageHeight": self.implantObj.implantImage.imageHeight,
                                            "labelWidth": self.implantObj.implantImage.labelWidth,
                                            "labelHeight": self.implantObj.implantImage.labelHeight,
                                            "labelOffsetX": self.implantObj.implantImage.labelOffsetX,
                                            "labelOffsetY": self.implantObj.implantImage.labelOffsetY,
                                            "removeImplant": self.implantObj.getRemovalArray().jsonString()]
            
            let image  = saveImageInDocumentDict(image: self.implantObj.implantImage.selectedImage!, imageName: "photo", key: "implantPicture")
            
            AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.addImplant, parameters: parameters, multipart: [image], serviceCount: 0, completion: { (response: AnyObject?, error: String?, errorCode: String?) in
                if error == nil {
                    ProgressManager.showSuccess(withStatus: "Implant uploaded successfully", on: self.rootViewController!.view)
                    if let controller = self.rootViewController!.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
                        controller.isComeFrom = 1
                        self.rootViewController?.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    ProgressManager.dismiss()
                    ProgressManager.showError(withStatus: error, on: self.rootViewController!.view)
                }
            })
        }
    }
}
