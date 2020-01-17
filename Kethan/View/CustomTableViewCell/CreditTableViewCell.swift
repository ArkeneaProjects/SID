//
//  CreditTableViewCell.swift
//  Kethan
//
//  Created by Ashwini on 15/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class CreditTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCredits: CustomLabel!
    @IBOutlet weak var imgSelect: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
