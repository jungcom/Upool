//
//  ViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var bottomStackView : UIStackView!
    
    let loginLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.login
        label.textAlignment = .center
        label.textColor = Colors.maroon
        label.font = UIFont(name: Fonts.helvetica, size: 32)
        return label
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.emailPlaceholder
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.passwordPlaceholder
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.login, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 24)
        button.backgroundColor = Colors.maroon
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let forgotPwdButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.forgotPwd, for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(handleForgottenPwd), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        label.text = Strings.noAccount
        return label
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.signUp, for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupStackViews()
        setupUI()
        setupConstraints()
    }
    
    func setupStackViews(){
        //Empty UI View
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
        bottomStackView = UIStackView(arrangedSubviews: [loginLabel, emailTextField, passwordTextField, loginButton, emptyUIView,bottomlabelStackView])
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 30
        bottomStackView.alignment = .center
    }
    
    func setupUI(){
        view.addSubview(bottomStackView)
    }
    
    func setupConstraints(){
        
        //Bottom Stack View Constraints
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        
        //Email and password field constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        //Login Button Constraints
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor, multiplier: 0.4).isActive = true
        
    }
    
    @objc func handleLogin(){
        print("login")
    }

    @objc func handleForgottenPwd(){
        print("no password")
    }
    
    @objc func handleSignUp(){
        print("SignUp")
    }

}

