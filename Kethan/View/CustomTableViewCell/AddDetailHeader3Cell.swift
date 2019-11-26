//
//  FamilyDocumentCell.swift
//  OverviewJLL
//
//  Created by Sunil on 28/12/18.
//  Copyright © 2018 Pankaj. All rights reserved.
//

import UIKit

class AddDetailHeader3Cell: UITableViewCell {

    @IBOutlet weak var viewListing: UIView!
    
    @IBOutlet weak var constViewXpos: NSLayoutConstraint!
    
    // MARK: - iVars
    var arrTableView: NSMutableArray = NSMutableArray()
    
    var tableIndexPath = IndexPath()
    
    var cellSelectionCompletion:((_ tableCell: Int) -> Void)?

    var heightForListingView = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateVehicleListing() {
        //self.constAddButtonHeight.constant = 20
       
        for view in self.viewListing.subviews {
            view.removeFromSuperview()
        }
        
        var lastView: UIView? = nil
        for index in 0..<arrTableView.count {
           
                if let processListingView: ProcessDocumentView = ProcessDocumentView.loadInstanceFromNib() as? ProcessDocumentView {
                    self.viewListing.addSubview(processListingView)
                    processListingView.translatesAutoresizingMaskIntoConstraints = false
                    
                    processListingView.lblProcess.text = String(format: arrTableView[index] as? String ?? "")
                    processListingView.backgroundColor = UIColor.gray
                    processListingView.tapCompletion = {
                        if self.cellSelectionCompletion != nil {
                            self.cellSelectionCompletion!(index)
                        }
                    }
                    
                    self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewListing, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0))
                    self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewListing, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: getCalculated(-5.0)))
                    if index == 0 {
                        self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewListing, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0))
                        
                        if self.arrTableView.count == 1 {
                            
                            self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewListing, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
                        }
                    } else if index == (arrTableView.count - 1) {
                        if lastView != nil {
                            self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lastView!, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: getCalculated(12.0)))
                        }
                        self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewListing, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: getCalculated(12.0)))
                    } else {
                        if lastView != nil {
                            self.viewListing.addConstraint(NSLayoutConstraint(item: processListingView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lastView!, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: getCalculated(12.0)))
                            
                        }
                    }
                    lastView = processListingView
                }
            
        }
        self.layoutIfNeeded()
    }
}
