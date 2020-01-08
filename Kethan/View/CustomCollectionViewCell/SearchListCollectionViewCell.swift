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
                if obj.imageData[0].objectLocation.imageWidth.count != 0 || obj.imageData[0].objectLocation.imageHeight.count != 0 {
                    self.imgPhoto.drawRectangle(frameSize: self.imgPhoto.frame.size, imageWidth: CGFloat(obj.imageData[0].objectLocation.imageWidth.floatValue()), imageHight: CGFloat(obj.imageData[0].objectLocation.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(obj.imageData[0].objectLocation.left.floatValue()), y: CGFloat(obj.imageData[0].objectLocation.top.floatValue()), width: CGFloat(obj.imageData[0].objectLocation.width.floatValue()), height: CGFloat(obj.imageData[0].objectLocation.height.floatValue())) )
                    }
                }
        }
    }
}
