//
//  VerifyOTPViewController.swift
//  Kethan
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SVPinView

class VerifyOTPViewController: BaseViewController {

    @IBOutlet weak var viewPin: SVPinView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNavBarWithTitle("Verify Email", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        viewPin.shouldSecureText = false
        viewPin.style = .box
        viewPin.font = UIFont(name: "HelveticaNeue", size: getCalculated(23.5))!
        viewPin.keyboardType = .phonePad
       /* viewPin.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()*/
        viewPin.font = UIFont(name: "HelveticaNeue", size: getCalculated(23.5))!
        viewPin.keyboardType = .phonePad
        viewPin.pinInputAccessoryView = UIView()
        viewPin.becomeFirstResponderAtIndex = 0
        viewPin.pinInputAccessoryView = UIView()
        viewPin.becomeFirstResponderAtIndex = 0
        viewPin.activeBorderLineThickness = getCalculated(1.5)
        viewPin.didFinishCallback = didFinishEnteringPin(pin:)
        viewPin.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @objc func dismissKeyboard() {
           self.view.endEditing(false)
    }
    
    func didFinishEnteringPin(pin: String) {
        print("Sucess ==\(pin)")
    }
    
    @IBAction func reSendOTPClickAction(_ sender: Any) {
    }
    
    @IBAction func signUpClickAction(_ sender: Any) {
        if let controller = self.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
            controller.isComeFromLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func referralClickAction(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
