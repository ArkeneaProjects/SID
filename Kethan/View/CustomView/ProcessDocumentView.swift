//
//  FamilyDocumentView.swift
//  OverviewJLL
//
//  Created by Sunil on 28/12/18.
//  Copyright © 2018 Pankaj. All rights reserved.
//

import UIKit

class ProcessDocumentView: UIView {
    @IBOutlet weak var lblProcess: CustomLabel!
    var tapCompletion: VoidCompletion? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if self.tapCompletion != nil {
            self.tapCompletion!()
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
