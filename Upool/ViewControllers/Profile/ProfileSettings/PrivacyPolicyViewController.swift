//
//  PrivacyPolicyViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/12/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable {

    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        navigationItem.title = "Privacy Policy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://termsfeed.com/privacy-policy/608fb3ff7c8a5bd9772a3be48770e851")!
        webView.load(URLRequest(url: url))
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
    }
}
