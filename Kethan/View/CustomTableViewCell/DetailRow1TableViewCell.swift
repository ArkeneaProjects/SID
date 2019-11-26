//
//  DetailRow1TableViewCell.swift
//  Kethan
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class DetailRow1TableViewCell: UITableViewCell {

    @IBOutlet weak var lblDiscription: CustomLabel!
    @IBOutlet weak var lblTitle: CustomLabel!
    
    @IBOutlet weak var viewCollection: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
