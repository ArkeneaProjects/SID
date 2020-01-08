//
//  ProcessListCell.swift
//  Kethan
//
//  Created by Ashwini on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ProcessListCell: UITableViewCell {

    @IBOutlet weak var lblProcessTitle: CustomLabel!
    @IBOutlet weak var lblLocation: CustomLabel!
    @IBOutlet weak var lblSurgeryDate: CustomLabel!
    
    @IBOutlet weak var btnDelete: CustomButton!
    
    @IBOutlet weak var constLocationImgHeight: NSLayoutConstraint!
    @IBOutlet weak var constSurgeryDateTop: NSLayoutConstraint!
    @IBOutlet weak var constSurgeryDateBottom: NSLayoutConstraint!
    @IBOutlet weak var constDateHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
