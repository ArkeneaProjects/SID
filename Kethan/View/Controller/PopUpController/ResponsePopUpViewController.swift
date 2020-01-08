//
//  ResponsePopUpViewController.swift
//  Kethan
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class ResponsePopUpViewController: BaseViewController, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtView: CustomTextView!
    @IBOutlet weak var btnLocation: CustomButton!
    @IBOutlet weak var btnSurgeryDate: CustomButton!
    var locationString = ""
    var dateString = ""
    
    var addCompletion:((_ str: String,_ location:String,_ date:String) -> Void)?
    
    @IBOutlet weak var btnClose: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNormalEditEnabled = false
        self.btnClose.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!("", "", "")
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.view.endEditing(true)
                self.addCompletion!(self.txtView.text!, self.locationString, self.dateString)
            }
        }
    }
    
    @IBAction func dateBtnClickAction(_ sender: CustomButton) {
        let controller: DatePopUpViewController = self.instantiate(DatePopUpViewController.self, storyboard: STORYBOARD.main) as? DatePopUpViewController ?? DatePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { date in
            if date.count > 0 {
                self.btnSurgeryDate.setTitle((date as String).components(separatedBy: " ")[0], for: .normal)
                self.dateString = date.convertLocalTimeZoneToUTC(actualFormat: "dd/MM/yyyy HH:mm", expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, actualZone: NSTimeZone.local, expectedZone: TimeZone(identifier: "UTC")!)
            }
        }
    }
    
    @IBAction func placeBtnClickAction(_ sender: CustomButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Custom Functions -
    func preparePopup(controller: BaseViewController) {
        
        if let parent = self.findParentBaseViewController() {
            controller.addViewController(controller: self, view: parent.view, parent: parent)
        } else {
            controller.addViewController(controller: self, view: controller.view, parent: controller)
        }
        self.preparePopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
    }
    
    func showPopup() {
        
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: self.btnClose)
        self.btnClose.alpha = 1.0
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
    }
    
    // MARK:- GMSAutocompleteViewControllerDelegate -
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let address = place.name
        self.btnLocation.setTitle(address, for: .normal)
        self.locationString = address!
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
