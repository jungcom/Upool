//
//  SignUpEmailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/21/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class SignUpEmailViewController: UIViewController {
    
    lazy var signupLabel : UILabel = {
        let label = UILabel()
        label.text = "To sign up, please type in your UMass email address."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var emailTextField = UITextField.getTextField(Strings.emailPlaceholder)
    
    lazy var continueButton : UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 20)
        button.backgroundColor = Colors.maroon
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.red
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavBar()
        setupUI()
    }
    
    func setupNavBar(){
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
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(signupLabel)
        view.addSubview(emailTextField)
        view.addSubview(errorLabel)
        view.addSubview(continueButton)
        
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        signupLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        //textfield Constraints
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: signupLabel.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: signupLabel.heightAnchor, multiplier: 0.4).isActive = true
        
        //error label constraints
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        //Continue button constraints
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        continueButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        
    }
    
    @objc func handleContinue(){
        guard let email = emailTextField.text, email != "" else {
            errorLabel.text =  "Please type in your UMass email"
            return
        }
        
        //Check for umass emails
//        let umassDotEdu = "umass.edu"
//        let domainOfEmail = email.suffix(9)
//
//        guard emailTextField.text != "", domainOfEmail == umassDotEdu else{
//            errorLabel.text =  "Email is not a UMass email"
//            return
//        }
        
        let signUpVC = SignUpViewController()
        signUpVC.email = email
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
    
    @objc func handleCancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
