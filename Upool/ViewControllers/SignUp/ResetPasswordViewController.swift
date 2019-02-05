//
//  ResetPasswordViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    let emailSentlabel : UILabel = {
        let label = UILabel()
        label.text = "To reset your password, please enter your email used to log into UPool."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    let emailTextField = UITextField.getTextField(Strings.emailPlaceholder)
    
    let continueButton : UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 24)
        button.backgroundColor = Colors.maroon
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavigationBar()
        setupUI()
        tapToDismissKeyboard()
    }
    
    func setNavigationBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancel))
        navigationItem.title = "Forgot Password"
        navigationItem.setLeftBarButton(doneItem, animated: true)
        if let navBar = self.navigationController?.navigationBar{
            navBar.barTintColor = Colors.maroon
            navBar.tintColor = UIColor.white
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(emailSentlabel)
        view.addSubview(emailTextField)
        view.addSubview(continueButton)
        
        //email Sent Label Constraints
        emailSentlabel.translatesAutoresizingMaskIntoConstraints = false
        emailSentlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        emailSentlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailSentlabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        emailSentlabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        //textfield Constraints
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailSentlabel.bottomAnchor, constant: 20).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: emailSentlabel.heightAnchor, multiplier: 0.4).isActive = true
        
        //Button Constraints
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        continueButton.heightAnchor.constraint(equalTo: emailSentlabel.heightAnchor, multiplier: 0.45).isActive = true
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleContinue(){
        guard let email = emailTextField.text else {return}
        
        let umassDotEdu = "umass.edu"
        let domainOfEmail = email.suffix(9)
        
        guard emailTextField.text != "", domainOfEmail == umassDotEdu else{
            print("Email domain is wrong")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                
            }
        }
    }

    func tapToDismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func handleTapped(){
        view.endEditing(true)
    }

}
