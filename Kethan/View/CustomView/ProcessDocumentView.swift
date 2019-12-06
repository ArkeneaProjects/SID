//
//  FamilyDocumentView.swift
//  OverviewJLL
//
//  Created by Sunil on 28/12/18.
//  Copyright © 2018 Pankaj. All rights reserved.
//

import UIKit

class ProcessDocumentView: UIView {
    
    @IBOutlet weak var btnRemove: CustomButton!
    @IBOutlet weak var lblProcess: CustomLabel!
    
    var tapCompletion:((_ IndexPath: IndexPath) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    @IBAction func btnRemoveClickAction(_ sender: CustomButton) {
        if self.tapCompletion != nil {
            self.tapCompletion!(sender.indexPath)
            }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
