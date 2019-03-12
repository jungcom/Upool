//
//  TermsAndConditionsViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/12/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://termsfeed.com/privacy-policy/608fb3ff7c8a5bd9772a3be48770e851")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
