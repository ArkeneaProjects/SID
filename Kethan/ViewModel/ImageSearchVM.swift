//
//  ImageSearchVM.swift
//  Kethan
//
//  Created by Apple on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ImageSearchVM: NSObject {

    override init() {
        
    }
    
    func searchImage(images: NSArray) {
        let dict: NSDictionary = [:]
        
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: "implant/analyzeImage", parameters: dict, multipart: images, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            print(response)
            print(error)
        }
//        guard var imageData = (images.firstObject as! UIImage).pngData() else { return  }
//
//        AFManager.request(method: .post, parameters: dict as! [String : Any], imageNames: ["abc"], images: [imageData]) { (response: Any?, error:Error?, success:Bool) in
//
//        }
    }
}
