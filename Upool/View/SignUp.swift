//
//  SignUp.swift
//  Upool
//
//  Created by Anthony Lee on 1/23/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension SignUpViewController{
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "Sign Up")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancel))
        navItem.leftBarButtonItem = doneItem
        navBar.barTintColor = Colors.maroon
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func setStackViews(){
        let emptyView = UIView()
        let emptyView2 = UIView()
        
        let termsStackView = UIStackView(arrangedSubviews: [agreeWithTermsLabel, termsAndConditionsButton])
        
        textFieldStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,reEnterPasswordTextField,nameTextField,phoneNumberTextField, emptyView2, signUpButton, emptyView, termsStackView])
        textFieldStackView.axis = .vertical
        textFieldStackView.alignment = .center
        textFieldStackView.spacing = 20
        textFieldStackView.distribution = .fillEqually
        
        view.addSubview(textFieldStackView)
        
    }
    
    func setConstraints(){
        //NavBar Constraints
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        //BottomStackView Constraints
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textFieldStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textFieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textFieldStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        //Textfield Constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        reEnterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        reEnterPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        //Signup Constraints
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
    }
    
    
}
