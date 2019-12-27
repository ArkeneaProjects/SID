//
//  SignUpViewController.swift
//  Kethan
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import Atributika

class SignUpViewController: BaseViewController, CountryListDelegate {
    
    @IBOutlet weak var lblTerms: AttributedLabel!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var lblSignIn: CustomLabel!
    // @IBOutlet weak var lblTerms: CustomLabel!
    
    @IBOutlet weak var txtReferral: CustomTextField!
    @IBOutlet weak var txtContact: CustomTextField!
    @IBOutlet weak var txtContryCode: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtProfession: CustomTextField!
    
    let signUpVM = SignUpViewModel()
    var countryList = CountryListViewController()
    
    var countyCode = ""
    
    // MARK: - iVars
    var arrcountry: [Country] {
        let countries = Countries()
        let arrList = countries.countries
        return arrList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNormalEditEnabled = true
        countryList.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //Terms and Condition Text
        self.lblTerms.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        paragraphStyle.lineHeightMultiple = 0.0
        paragraphStyle.alignment = .center
        
        let all = Style.font(APP_FONT.regularFont(withSize: 14)).foregroundColor(UIColor(rgb: 84.0/255.0, alpha: 1.0)).paragraphStyle(paragraphStyle)
        
        let link = Style("a")
            .foregroundColor(UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), .normal).foregroundColor(UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), .highlighted)
        
        lblTerms.attributedText = "By signing up you accept the <a href=\"Termofservices\">Terms of Service</a> and <a href=\"Privacy Policy\">Privacy Policy</a>".style(tags: link)
            .styleAll(all)
        lblTerms.onClick = { label, detection in
            switch detection.type {
                
            case .tag(let tag):
                if let href = tag.attributes["href"] {
                    print(href)
                    if let controller = self.instantiate(TermsConditionViewController.self, storyboard: STORYBOARD.leftMenu) as? TermsConditionViewController {
                        controller.isPage = (href == "Termofservices") ?0:1
                        controller.urlString = "https://www.google.com/"
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            default:
                break
            }
        }
        
        //Already SignUp Text
        let signInAttributedString = NSMutableAttributedString(string: "Already have an account? Sign In", attributes: [
            .font: APP_FONT.regularFont(withSize: 14.0),
            .foregroundColor: UIColor.black
        ])
        signInAttributedString.addAttribute(.foregroundColor, value: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), range: NSRange(location: 24, length: 8))
        self.lblSignIn.attributedText = signInAttributedString
        let signInGesture = UITapGestureRecognizer(target: self, action: #selector(signInLabel(gesture:)))
        self.lblSignIn.isUserInteractionEnabled = true
        self.lblSignIn.addGestureRecognizer(signInGesture)
        // Do any additional setup after loading the view.
        
        //County Code
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        for contry in arrcountry where contry.countryCode == countryCode {
            //self.txtContryCode.text = "+\(contry.phoneExtension)"
            self.countyCode = "+\(contry.phoneExtension)"
            self.txtContryCode.text = "\(contry.flag!) +\(contry.phoneExtension)"
        }
        
        //Check Social Media Signup
        if self.signUpVM.loginVM != nil {
            self.txtEmail.isUserInteractionEnabled = false
            self.txtEmail.text = self.signUpVM.loginVM?.email
            self.txtName.text = self.signUpVM.loginVM?.fullName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.signUpVM.clearAllData()
        self.signUpVM.name = self.txtName.text!
        self.signUpVM.email = self.txtEmail.text!
        self.signUpVM.contactNumber = self.txtContact.text!
        self.signUpVM.profession = self.txtProfession.text!
        self.signUpVM.referral = self.txtReferral.text!
        self.signUpVM.countryCode = self.countyCode
        
        self.signUpVM.validateSignUp(controller: self)
        
        //        if let controller = self.instantiate(VerifyOTPViewController.self, storyboard: STORYBOARD.signup) as? VerifyOTPViewController {
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
    }
    
    func selectedCountry(country: Country) {
        self.countyCode = "+\(country.phoneExtension)"
        self.txtContryCode.text = "\(country.flag!) +\(country.phoneExtension)"
    }
    
    @objc func signInLabel(gesture: UITapGestureRecognizer) {
        let text = self.lblSignIn.text!
        let signInRange = (text as NSString).range(of: "Sign In")
        
        if gesture.didTapAttributedTextInLabel(label: self.lblSignIn, inRange: signInRange) {
            print("Tapped sign in")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Tapped none")
        }
    }
    
    // MARK: - UITextFieldDelegate
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtContryCode {
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
        if textField == self.txtEmail &&  textField.text!.count >= 50 {
            return false
        }
        if textField == self.txtContact &&  textField.text!.count >= 10 {
            return false
        }
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtName {
            self.txtEmail.becomeFirstResponder()
        } else if textField == self.txtEmail {
            self.txtContact.resignFirstResponder()
        }
        return true
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

