//
//  UIImageView_Addition.swift
//  ORLink
//
//  Created by Arkenea on 10/08/17.
//  Copyright © 2017 Arkenea Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import SpinKit

extension UIImageView {
    
    func setImageWithURL(_ strURL: String, _ insertLoader: Bool, _ placeholder: Bool, _ completion: VoidCompletion?) {
       print("Aj image",strURL)
       let urlNew: String = strURL.trimmingCharacters(in: .whitespaces)
        if let imageURL: URL = URL(string: urlNew) {
            SDWebImageManager.shared().cachedImageExists(for: imageURL, completion: { (exists: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.backgroundColor = UIColor.clear
                    if exists == false && insertLoader == true {
                        self.image = nil
                        
                       // let size: Float = Float(((self.frame.size.width > self.frame.size.height) ? self.frame.size.height: self.frame.size.width) / 3.0) * 2.0
                       // addSpinnerWithStyle(spinnerStyle: RTSpinKitViewStyle.styleBounce, withColor: APP_COLOR.defaultGray, withBackgroundColor: UIColor.clear, withParent: self, ofSize: (size > 50.0) ?50.0: size)
                    } else if exists == true {
                        self.image = nil
                    }
                    
                    let placeholderImage = (placeholder == true) ?UIImage(named: "default-male")!: self.image
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        self.sd_setImage(with: imageURL, placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, completed: { (image: UIImage?, _, _, _) in
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                removeSpinnerFromView(parentView: self)
                                if image != nil {
                                    
                                    self.image = image
                                } else if placeholder == false {
                                    self.image = UIImage()
                                } else {
                                    self.image = placeholderImage
                                }
                                
                                if completion != nil {
                                    completion!()
                                }
                            })
                        })
                    })
                })
            })
        } else {
            self.image = UIImage(named: "default-male")
        }
    }
    
    func setImageWithPlaceHolderImage(_ strURL: String, _ insertLoader: Bool, _ placeholder: Bool, _ placeImage: String, _ completion: VoidCompletion?) {
        
        let urlNew: String = strURL.trimmedString().replacingOccurrences(of: " ", with: "%20")
        if let imageURL: URL = URL(string: String(format: "%@", urlNew)) {
            
            SDWebImageManager.shared().cachedImageExists(for: imageURL, completion: { (exists: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.backgroundColor = UIColor.clear
                    if exists == false && insertLoader == true {
                        self.image = nil
                        
                        let size: Float = Float(((self.frame.size.width > self.frame.size.height) ? self.frame.size.height: self.frame.size.width) / 3.0) * 2.0
                        addSpinnerWithStyle(spinnerStyle: RTSpinKitViewStyle.styleBounce, withColor: APP_COLOR.color1, withBackgroundColor: UIColor.clear, withParent: self, ofSize: (size > 50.0) ?50.0: size)
                    } else if exists == true {
                        self.image = nil
                    }
                    
                    let image = (placeholder == true) ?UIImage(named: placeImage)!: self.image
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        self.sd_setImage(with: imageURL, placeholderImage: image, options: SDWebImageOptions.lowPriority, completed: { (image: UIImage?, _, _, _) in
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                removeSpinnerFromView(parentView: self)
                                if image != nil {
                                    
                                    self.image = image
                                } else if placeholder == false {
                                    self.image = UIImage()
                                }
                                
                                if completion != nil {
                                    completion!()
                                }
                            })
                        })
                    })
                })
            })
        } else {
            self.image = UIImage(named: placeImage)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imageIsNullOrNot(imageName: UIImage) -> Bool {
        
        let size = CGSize(width: 0, height: 0)
        if imageName.size.width == size.width {
            return false
        } else {
            return true
        }
    }
}
