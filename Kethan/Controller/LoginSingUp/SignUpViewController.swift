//
//  SignUpViewController.swift
//  Kethan
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var lblSignIn: CustomLabel!
    @IBOutlet weak var lblTerms: CustomLabel!
    
    @IBOutlet weak var lblReferral: CustomTextField!
    @IBOutlet weak var lblContact: CustomTextField!
    @IBOutlet weak var lblVerifyEmail: CustomTextField!
    @IBOutlet weak var lblEmail: CustomTextField!
    @IBOutlet weak var lblName: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let attributedString = NSMutableAttributedString(string: "By signing up you accept the Terms of Service and Privacy Policy", attributes: [
          .font: UIFont(name: "HelveticaNeue", size: getCalculated(14.0))!,
          .foregroundColor: UIColor.black
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), range: NSRange(location: 29, length: 16))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), range: NSRange(location: 50, length: 14))
        
        self.lblTerms.attributedText = attributedString
        let gesture = UITapGestureRecognizer(target: self, action: #selector(termsLabel(gesture:)))
        self.lblTerms.isUserInteractionEnabled = true
        self.lblTerms.addGestureRecognizer(gesture)
        
        let signInAttributedString = NSMutableAttributedString(string: "Already have an account? Sign In", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: getCalculated(14.0))!,
          .foregroundColor: UIColor.black
        ])
        signInAttributedString.addAttribute(.foregroundColor, value: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), range: NSRange(location: 24, length: 8))
        self.lblSignIn.attributedText = signInAttributedString
        let signInGesture = UITapGestureRecognizer(target: self, action: #selector(signInLabel(gesture:)))
        self.lblSignIn.isUserInteractionEnabled = true
        self.lblSignIn.addGestureRecognizer(signInGesture)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
    }
    
    @objc func termsLabel(gesture: UITapGestureRecognizer) {
        let text = self.lblTerms.text!
        let termsofServiceRange = (text as NSString).range(of: "Terms of Service")
        let termsRange = (text as NSString).range(of: "Terms")
        let ofRange = (text as NSString).range(of: "of")
        let serviceRange = (text as NSString).range(of: "Service")
        
        let privacyRange = (text as NSString).range(of: "Privacy")
        let policyRange = (text as NSString).range(of: "Policy")

        if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: termsRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: ofRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: serviceRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: termsofServiceRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: privacyRange) {
            print("Tapped privacy")
        } else if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: policyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
