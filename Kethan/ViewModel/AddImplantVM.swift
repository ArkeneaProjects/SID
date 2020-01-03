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
    var arrImages = NSMutableArray()
    var implantObj = SearchResult()
    
    func uploadImplant(){
        let parameters: NSDictionary = ["accessToken": AppConstant.shared.loggedUser.accesstoken,
                                        "labelName": self.implantObj.objectName,
                                        "implantManufacture": self.implantObj.implantManufacture,
                                        "imageWidth": self.implantObj.implantImage.imageWidth,
                                        "imageHeight": self.implantObj.implantImage.imageHeight,
                                        "labelWidth": self.implantObj.implantImage.labelWidth,
                                        "labelHeight": self.implantObj.implantImage.labelHeight,
                                        "labelOffsetX": self.implantObj.implantImage.labelOffsetX,
                                        "labelOffsetY": self.implantObj.implantImage.labelOffsetY,
                                        "removeImplant": self.implantObj.removImplant]
        
        let arrMultipart: NSMutableArray = NSMutableArray()
        
        if self.implantObj.implantImage.uploadImagePath.trimmedString().count > 0 {
            let name: String = URL(fileURLWithPath: self.implantObj.implantImage.uploadImagePath).lastPathComponent
            arrMultipart.add(NSDictionary(dictionary: ["key": "implantPicture", "name": name, "path": self.implantObj.implantImage.uploadImagePath]))
        }
        
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.addImplant, parameters: parameters, multipart: arrMultipart, serviceCount: 0, completion: { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                ProgressManager.showSuccess(withStatus: "Implant uploaded successfully", on: self.view)
            } else {
                ProgressManager.dismiss()
                ProgressManager.showError(withStatus: error, on: self.view)
            }
        })
    }
}
