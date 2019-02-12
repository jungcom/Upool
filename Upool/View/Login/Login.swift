//
//  Login.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension LoginViewController{
    func setupStackViews(){
        //Empty UIVIew
        let emptyUIView = UIView()
        
        //Label + Signup button
        let labelAndSignUpStackView = UIStackView(arrangedSubviews: [dontHaveAccLabel, signUpButton])
        labelAndSignUpStackView.axis = .horizontal
        labelAndSignUpStackView.spacing = 5
        labelAndSignUpStackView.alignment = .center
        
        // bottom Label StackView
        let bottomlabelStackView = UIStackView(arrangedSubviews: [forgotPwdButton,labelAndSignUpStackView])
        bottomlabelStackView.axis = .vertical
        bottomlabelStackView.alignment = .center
        
        //Bottom stack view
        bottomStackView = UIStackView(arrangedSubviews: [ emptyUIView,loginLabel, emailTextField, passwordTextField, errorLabel ,loginButton,bottomlabelStackView])
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 25
        bottomStackView.alignment = .center
        bottomStackView.backgroundColor = UIColor.white
        
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        bottomContainer.addSubview(bottomStackView)
        view.addSubview(bottomContainer)
        view.addSubview(umassBackgroundImageView)
        view.bringSubviewToFront(bottomContainer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupConstraints(){
        
        //BottomContainer View Constraints
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true
        
        //Bottom Stack View Constraints
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor, constant:-15).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomStackView.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        //Email and password field constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        //Login Button Constraints
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.4).isActive = true
        
        //Umass Image constraints
        umassBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        umassBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        umassBackgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        umassBackgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        umassBackgroundImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.55).isActive = true
        
    }
    
    //Textfield Notifications
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Login Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
}
