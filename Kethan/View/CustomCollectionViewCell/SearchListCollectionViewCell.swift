//
//  SearchListCollectionViewCell.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnView: CustomButton!
    
    @IBOutlet weak var lblSubTitle: CustomLabel!
    @IBOutlet weak var lblTitle: CustomLabel!
    @IBOutlet weak var lblMatch: CustomLabel!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
