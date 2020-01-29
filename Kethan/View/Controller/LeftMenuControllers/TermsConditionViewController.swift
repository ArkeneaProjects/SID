//
//  TermsConditionViewController.swift
//  Kethan
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import WebKit

class TermsConditionViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var webMKView: WKWebView!
    var isPage = 0 // 0 for Terms and Condition, 1 for Privacy, 2 for FAQ, 3 for About
    var urlString = ""
   // @IBOutlet weak var webView: mkwebvi
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = (self.isPage == 0) ?"Terms of Service":(self.isPage == 1) ?"Privacy Policy":(self.isPage == 2) ?"FAQs":"About Us"

        self.addNavBarWithTitle(page, withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        ProgressManager.show(withStatus: "", on: self.view)

        let aboutVM = AboutUsVM()
        aboutVM.callAPI(page: page) { (content) in
            if content != "" {
                self.webMKView.backgroundColor = .white
                self.webMKView.loadHTMLString(content, baseURL: nil)
                self.webMKView.allowsBackForwardNavigationGestures = false
                ProgressManager.dismiss()
            } else {
                ProgressManager.showError(withStatus: MESSAGES.errorOccured, on: self.view)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         print("Strat to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         print("finish to load")
        ProgressManager.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        ProgressManager.showError(withStatus: error.localizedDescription, on: self.view)

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
