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
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.title = "Sign Up"
        navigationItem.setLeftBarButton(doneItem, animated: true)
        if let navBar = self.navigationController?.navigationBar{
            navBar.barTintColor = Colors.maroon
            navBar.tintColor = UIColor.white
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
    }
    
    func setStackViews(){
        //let emptyView = UIView()        
        let termsStackView = UIStackView(arrangedSubviews: [agreeWithTermsLabel, termsAndConditionsButton])
        
        textFieldStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,reEnterPasswordTextField,firstNameTextField,lastNameTextField, errorLabel, signUpButton, termsStackView])
        textFieldStackView.axis = .vertical
        textFieldStackView.alignment = .center
        textFieldStackView.spacing = 20
        textFieldStackView.distribution = .fillEqually
        
        view.addSubview(textFieldStackView)
        
    }
    
    func setConstraints(){
        
        //BottomStackView Constraints
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:-10).isActive = true
        textFieldStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textFieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textFieldStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
        
        //Textfield Constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
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
    
    //Status Bar Light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Textfield Notifications
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
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
