//
//  SignUpViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/23/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    let navBar = UINavigationBar()
    
    var textFieldStackView : UIStackView!
    
    let profileImageButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    let emailTextField = UITextField.getTextField(Strings.emailPlaceholder)
    let passwordTextField = UITextField.getTextField(Strings.passwordPlaceholder)
    let reEnterPasswordTextField = UITextField.getTextField(Strings.reEnterPasswordPlaceholder)
    let nameTextField = UITextField.getTextField(Strings.namePlaceholder)
    let phoneNumberTextField = UITextField.getTextField(Strings.phoneNumberPlaceholder)
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.signUp, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 24)
        button.backgroundColor = Colors.maroon
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let agreeWithTermsLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.acceptTermsAndConditions
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        return label
    }()
    
    let termsAndConditionsButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.termsAndConditions, for: .normal)
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 12)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: Strings.termsAndConditions,
                                                        attributes: stringAtt)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setNavigationBar()
        setStackViews()
        setConstraints()
    }
    

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
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        print("signUp")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
