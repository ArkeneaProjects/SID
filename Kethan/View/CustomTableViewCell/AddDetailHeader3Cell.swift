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
    var arrTableView = NSMutableArray()
    
    var tableIndexPath = IndexPath()
    
    var cellSelectionCompletion:((_ tableCell: Int) -> Void)?
    
    var heightForListingView = 0.0
    
    @IBOutlet weak var btnAddResponse: CustomButton!
    @IBOutlet weak var btnSeeAll: CustomButton!
    
    var seeAllProcessCompletion:(() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func seeAllProcessCompletion(_ sender:CustomButton) {
        if self.seeAllProcessCompletion != nil {
            
            self.seeAllProcessCompletion!()
        }
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
                
                let process = arrTableView.object(at: index) as! Implant
                
                processListingView.lblProcess.text = process.removalProcess
                processListingView.btnRemove.alpha =  (process.isApproved == "0" && process.userId == AppConstant.shared.loggedUser.userId) ?1.0:0

                if process.surgeryDate.count > 0 {
                    processListingView.lblSurgeryDate.text = process.surgeryDate.convertLocalTimeZoneToUTC(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: "dd/MM/yyyy", actualZone: TimeZone(identifier: "UTC")!, expectedZone: NSTimeZone.local)
                    processListingView.constDateHeight.constant = 18.0
                } else {
                    processListingView.constDateHeight.constant = 0.0
                    processListingView.constSurgeryDateTop.constant = 0.0
                }
                
                if process.surgeryLocation.count > 0 {
                    processListingView.lblLocation.text = process.surgeryLocation
                    processListingView.constLocationImgHeight.constant = 18.0
                } else {
                    processListingView.constLocationImgHeight.constant = 0.0
                    processListingView.constSurgeryDateBottom.constant = 0.0
                }
                
                processListingView.layoutIfNeeded()
                processListingView.backgroundColor = UIColor.gray
                processListingView.btnRemove.indexPath = IndexPath(row: index, section: 0)
                processListingView.tapCompletion = { indexPath in
                    if self.cellSelectionCompletion != nil {
                        self.cellSelectionCompletion!(indexPath.row)
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
