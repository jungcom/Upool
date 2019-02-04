//
//  EmailSentViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class EmailSentViewController: UIViewController {

    let emailSentlabel : UILabel = {
        let label = UILabel()
        label.text = "We have sent you an email with a verification link. Please follow the instructions in the email. "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    let doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 24)
        button.backgroundColor = Colors.maroon
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        setupUI()
    }

    func setupNavBar(){
        navigationItem.hidesBackButton = true
        navigationItem.title = "Email Sent"
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(emailSentlabel)
        view.addSubview(doneButton)
        
        emailSentlabel.translatesAutoresizingMaskIntoConstraints = false
        emailSentlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        emailSentlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailSentlabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        emailSentlabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: emailSentlabel.bottomAnchor, constant: 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        doneButton.heightAnchor.constraint(equalTo: emailSentlabel.heightAnchor, multiplier: 0.4).isActive = true
        
        
    }
    
    @objc func handleBack(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
