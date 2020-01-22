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
    var arrDeletedProcess = NSMutableArray()
    var arrDeletedImage = NSMutableArray()
    
    func uploadImplant(_ controller: BaseViewController) {
        self.rootViewController = controller
        if self.implantObj._id.count == 0 {
            if implantObj.objectName.count < 1 {
                ProgressManager.showError(withStatus: ERRORS.EmptyBrandName, on: self.rootViewController!.view)
                return
            } else if implantObj.implantManufacture.count < 1 {
                ProgressManager.showError(withStatus: ERRORS.EmptyManufacturer, on: self.rootViewController!.view)
                return
            }
            
            if implantObj.implantImage.selectedImage == nil {
                ProgressManager.showError(withStatus: ERRORS.EmptyImage, on: self.rootViewController!.view)
                return
            }
        } else {
            //if implantObj.implantImage.selectedImage == nil {
             //   ProgressManager.showError(withStatus: ERRORS.EmptyImage, on: self.rootViewController!.view)
             //   return
            //}
            //            else if implantObj.removImplant.count == 0 {
            //
            //                    ProgressManager.showError(withStatus: ERRORS.EmptyRemovalProcess, on: self.rootViewController!.view)
            //                    return
            //                }
            //            }
        }
        ProgressManager.show(withStatus: "\((self.implantObj._id.count != 0) ?"Updating":"Uploading") Implant...", on: self.rootViewController!.view)
        
        let parameters: NSDictionary =  [
            "implantId": self.implantObj._id,
            "labelName": self.implantObj.objectName,
            "implantManufacture": self.implantObj.implantManufacture,
            "imageWidth": self.implantObj.implantImage.imageWidth,
            "imageHeight": self.implantObj.implantImage.imageHeight,
            "labelWidth": self.implantObj.implantImage.labelWidth,
            "labelHeight": self.implantObj.implantImage.labelHeight,
            "labelOffsetX": self.implantObj.implantImage.labelOffsetX,
            "labelOffsetY": self.implantObj.implantImage.labelOffsetY,
            "removeImplant": self.implantObj.getRemovalArray().jsonString(),
            "deletedprocess": self.arrDeletedProcess.jsonString(),
            "deletedimage": self.arrDeletedImage.jsonString()]
        
        var array = Array<Any>()
        if self.implantObj.implantImage.selectedImage != nil { 
            let image  = saveImageInDocumentDict(image: self.implantObj.implantImage.selectedImage!, imageName: "photo", key: "implantPicture")
            array = [image]
        }
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: (self.implantObj._id.count != 0) ?SUFFIX_URL.editImplant:SUFFIX_URL.addImplant, parameters: parameters, multipart: array as NSArray, serviceCount: 0, completion: { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                ProgressManager.showSuccess(withStatus: "Implant \((self.implantObj._id.count != 0) ?"updated":"uploaded") successfully", on: self.rootViewController!.view)
                if let controller = self.rootViewController!.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
                    FileManager.default.clearTmpDirectory()
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
