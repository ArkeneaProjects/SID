//
//  SubScriptionCollectionViewCell.swift
//  Kethan
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SubScriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnSubscribe: CustomButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!

    @IBOutlet weak var lblValid: CustomLabel!
    @IBOutlet weak var lblPlan: CustomLabel!
    @IBOutlet weak var lblPrice: CustomLabel!
    @IBOutlet weak var imgBG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
