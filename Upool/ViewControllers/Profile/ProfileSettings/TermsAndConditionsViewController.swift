//
//  TermsAndConditionsViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/15/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class TermsAndConditionsViewController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable {
    
    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        navigationItem.title = "Terms & Conditions"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://www.websitepolicies.com/policies/view/JLzTJSKB")!
        webView.load(URLRequest(url: url))
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
    }
}
