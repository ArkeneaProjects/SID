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
    var isPage = 0 // 0 for Terms and Condition, 1 for Privacy, 2 for FAQ
    var urlString = ""
   // @IBOutlet weak var webView: mkwebvi
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle((self.isPage == 0) ?"Terms of Service":(self.isPage == 1) ?"Privacy Policy":"FAQs", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        let request = NSURLRequest(url: URL(string: urlString)!)
        webMKView.load(request as URLRequest)
        webMKView.allowsBackForwardNavigationGestures = false
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Delegate
   
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         print("Strat to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         print("finish to load")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
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
