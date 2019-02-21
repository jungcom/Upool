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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.navigationItem.title = "Sign Up"
    }
    
    func setStackViews(){
        //let emptyView = UIView()
        let termsStackView = UIStackView(arrangedSubviews: [agreeWithTermsLabel, termsAndConditionsButton])
        termsStackView.spacing = 0
        termsStackView.distribution = .fillProportionally
        
        textFieldStackView = UIStackView(arrangedSubviews: [passwordTextField,reEnterPasswordTextField,firstNameTextField,lastNameTextField, errorLabel, signUpButton])
        textFieldStackView.axis = .vertical
        textFieldStackView.alignment = .center
        textFieldStackView.spacing = 20
        textFieldStackView.distribution = .fillEqually
        
        view.addSubview(textFieldStackView)
        view.addSubview(termsStackView)
        
        //TermsAndCondition Constraints
        termsStackView.translatesAutoresizingMaskIntoConstraints = false
        termsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:-10).isActive = true
        termsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        termsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        termsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setConstraints(){
        
        //TextFieldStackView Constraints
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:40).isActive = true
        textFieldStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textFieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textFieldStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        //Textfield Constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        reEnterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        reEnterPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        //Signup Constraints
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
    }
    
    //Textfield Notifications
//    func setupKeyboardNotifications(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            print("notification: Keyboard will show")
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height/2
//            }
//        }
//
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
}
