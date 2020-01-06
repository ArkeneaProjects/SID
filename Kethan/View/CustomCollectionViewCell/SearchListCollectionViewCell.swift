//
//  SearchListCollectionViewCell.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SDWebImage
class SearchListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblSubTitle: CustomLabel!
    @IBOutlet weak var lblTitle: CustomLabel!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configuration(obj: SearchResult) {
        self.lblTitle.text = obj.objectName
        self.lblSubTitle.text = obj.implantManufacture
        if obj.imageData.count > 0 {
            self.imgPhoto.sd_setImage(with: URL(string: obj.imageData[0].imageName), placeholderImage: nil, options: .continueInBackground) { (image, error, types, url) in
               self.imgPhoto.drawRectangle(frameSize: self.imgPhoto.frame.size, imageWidth: image?.size.width ?? 0.0, imageHight: image?.size.height ?? 0.0, drawSize: CGRect(x: CGFloat(obj.imageData[0].objectLocation.left.floatValue()), y: CGFloat(obj.imageData[0].objectLocation.top.floatValue()), width: CGFloat(obj.imageData[0].objectLocation.width.floatValue()), height: CGFloat(obj.imageData[0].objectLocation.height.floatValue())) )
              //  self.imgPhoto.image = image?.drawRectangleOnImage(drawSize: CGRect(x: CGFloat(obj.imageData[0].objectLocation.left.floatValue()), y: CGFloat(obj.imageData[0].objectLocation.top.floatValue()), width: CGFloat(obj.imageData[0].objectLocation.width.floatValue()), height: CGFloat(obj.imageData[0].objectLocation.height.floatValue())))
                           }
//            self.imgPhoto.sd_setImage(with: URL(string: model.imageData[0].imageName), placeholderImage: nil, options: .continueInBackground, context: nil)
        }
    }
}
