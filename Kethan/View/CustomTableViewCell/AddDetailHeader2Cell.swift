//
//  AddDetailHeader2Cell.swift
//  Kethan
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class AddDetailHeader2Cell: UITableViewCell {

    @IBOutlet weak var btnLocation: CustomButton!
    @IBOutlet weak var btnSurgeryDate: CustomButton!
    
    @IBOutlet weak var lblImplant: CustomLabel!
    @IBOutlet weak var lblManufacture: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
