//
//  EditProfileViewController.swift
//  Kethan
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, GalleryManagerDelegate, CountryListDelegate {

    @IBOutlet weak var txtCountryCode: CustomTextField!
    @IBOutlet weak var txtMobile: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtProfession: CustomTextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    var imagePicker: GalleryManager!
    
    let editVM = EditProfileVM()
    
    //County Code
    var countryList = CountryListViewController()
    var countyCode = ""
    var arrcountry: [Country] {
           let countries = Countries()
           let arrList = countries.countries
           return arrList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryList.delegate = self
        
        self.addNavBarWithTitle("Profile", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)
        
        // Profile Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileClickAction(_:)))
        self.imgProfile.addGestureRecognizer(tapGesture)
        self.imgProfile.isUserInteractionEnabled = true
        
        self.displayData()
    }
    
    func displayData() {
        self.imgProfile.setImageWithPlaceHolderImage(AppConstant.shared.loggedUser.userImage, false, true, PLACEHOLDERS.profile, nil)
        self.txtName.text = AppConstant.shared.loggedUser.name
        self.txtMobile.text = AppConstant.shared.loggedUser.contactNumber
        self.txtProfession.text = AppConstant.shared.loggedUser.profession
        
        //County Code
        let countyCode = (AppConstant.shared.loggedUser.country_code.count == 0) ?(Locale.current as NSLocale).object(forKey: .countryCode) as? String:AppConstant.shared.loggedUser.country_code

        for contry in arrcountry where contry.countryCode == countyCode {
            //self.txtContryCode.text = "+\(contry.phoneExtension)"
            self.countyCode = "+\(contry.phoneExtension)"
            self.txtCountryCode.text = "\(contry.flag!) +\(contry.phoneExtension)"
        }
    }
    
    // MARK: - Button Action
    @IBAction func saveClickAction(_ sender: Any) {
        
        editVM.clearAllData()
        editVM.name = self.txtName.text!
        editVM.countryCode = self.countyCode
        editVM.contactNumber = self.txtMobile.text!
        editVM.profession = self.txtProfession.text!
        
        editVM.validateEditProfile(self)
        
    }
    
    @IBAction func editImageClickAction(_ sender: Any) {
        self.showActionSheet(headerTitle: "Choose Image From", cameraTitle: "Camera", galleryTitle: "Gallery", galleryCompletion: {
            self.imagePicker.present(croppingStyle: .circular, isCrop: true, isCamera: false)
        }) {
            self.imagePicker.present(croppingStyle: .circular, isCrop: true, isCamera: true)
        }
    }
    
    @objc func profileClickAction(_ sender: Any) {
        self.openGalleryList(indexpath: IndexPath(row: 0, section: 0), imgNameArr: NSMutableArray(array: [AppConstant.shared.loggedUser.userImage]), sourceView: self.imgProfile)
    }
    
    func selectedCountry(country: Country) {
        self.countyCode = "+\(country.phoneExtension)"
        self.txtCountryCode.text = "\(country.flag!) +\(country.phoneExtension)"
    }
    
    func didSelect(image: UIImage?) {
        self.imgProfile.image = image
        editVM.imgProfile = self.imgProfile.image
    }
    
    // MARK: - UITextFieldDelegate
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtCountryCode {
            self.view.endEditing(true)
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
            return false
        } else if textField == self.txtProfession {
            self.view.endEditing(true)
            let controller: SelectProfessionViewController = self.instantiate(SelectProfessionViewController.self, storyboard: STORYBOARD.main) as? SelectProfessionViewController ?? SelectProfessionViewController()
            controller.preparePopup(selectedText: self.txtProfession.text!, controller: self)
            controller.showPopup()
            controller.addCompletion = { profession in
                self.txtProfession.text = profession
            }
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText: String = NSString(string: textField.text!).replacingCharacters(in: range, with: string) as String
        if string == "" {
            return true
        }
        if textField == self.txtName {
            if textField.text!.count >= 100 {
                return false
            }
        }
        if textField == self.txtName {
            return finalText.hasOnlyAlphabets()
        }
        if textField == self.txtMobile &&  textField.text!.count >= 16 {
            return false
        }
        return true
    }

}
