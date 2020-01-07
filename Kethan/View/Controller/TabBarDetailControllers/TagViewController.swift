//
//  TagViewController.swift
//  Kethan
//
//  Created by Apple on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class TagViewController: BaseViewController {
    
    @IBOutlet weak var cropView: CropPickerView!
    var selectedImage: UIImage?
    var isComeFromCreate: Bool = true
    var continueCompletion: ((_ cordinate: ImplantImage) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Tag View", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        self.cropView.image = self.selectedImage
        self.cropView.isCrop = true
    }
    
    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size

        guard let imageSize = imgSize else {
            return CGRect.zero
        }

        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)

        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2

        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y

        return imageRect
    }
    
    @IBAction func continuClickAction(_ sender: Any) {
        print("Dimention==\(cropView.getCropViewDimention().frame)")
        let croppedFrame = cropView.getCropViewDimention().frame
        let rect = self.calculateRectOfImageInImageView(imageView: self.cropView.imageView)
        let actualX = croppedFrame.origin.x - rect.origin.x
        let actualY = croppedFrame.origin.y - rect.origin.y
        print(actualX, actualY)
  
        if self.continueCompletion != nil {
            let impantObj = ImplantImage()
            impantObj.imageWidth = String(format: "%.1f", self.cropView.actualImageWidth)
            impantObj.imageHeight = String(format: "%.1f", self.cropView.actualImageHeight)
            impantObj.labelOffsetX = String(format: "%.1f", actualX)
            impantObj.labelOffsetY = String(format: "%.1f", actualY)
            impantObj.labelWidth = String(format: "%.1f", self.cropView.tagViewWidth)
            impantObj.labelHeight = String(format: "%.1f", self.cropView.tagViewHeight)
            impantObj.selectedImage = self.cropView.image!
            
            self.continueCompletion!(impantObj)
            self.navigationController?.popViewController(animated: true)
        } else {
            if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
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
