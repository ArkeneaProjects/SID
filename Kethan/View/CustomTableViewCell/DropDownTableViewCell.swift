//
//  DropDownTableViewCell.swift
//  Kethan
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
