//
//  CreditHistoryTableViewCell.swift
//  Kethan
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class CreditHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAmount: CustomLabel!
    @IBOutlet weak var lblDiscription: CustomLabel!
    @IBOutlet weak var lblDate: CustomLabel!
    @IBOutlet weak var lblTitle: CustomLabel!
    
    @IBOutlet weak var imgReferral: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
