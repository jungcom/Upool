//
//  ViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let bottomStackView : UIStackView? = nil
    
    let loginLabel : UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.textAlignment = .center
        label.textColor = Colors.maroon
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(loginLabel)
        
    }


}

