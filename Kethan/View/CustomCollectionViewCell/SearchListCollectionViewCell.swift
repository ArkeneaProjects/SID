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
    func configuration(model: SearchResult) {
        self.lblTitle.text = model.objectName
        self.lblSubTitle.text = model.implantManufacture
        if model.imageData.count > 0 {
            self.imgPhoto.sd_setImage(with: URL(string: model.imageData[0].imageName), placeholderImage: nil, options: .continueInBackground, context: nil)
        }
    }
}
