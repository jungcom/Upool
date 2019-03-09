//
//  SignUpView.swift
//  Upool
//
//  Created by Anthony Lee on 3/8/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class SignUpView : UIView{
    
    var textFieldStackView : UIStackView!
    
    let profileImageButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    //TextFields
    var email : String?
    
    let passwordTextField : UITextField = {
        let txtField = UITextField.getTextField(Strings.passwordPlaceholder)
        txtField.isSecureTextEntry = true
        return txtField
    }()
    let reEnterPasswordTextField : UITextField = {
        let txtField = UITextField.getTextField(Strings.reEnterPasswordPlaceholder)
        txtField.isSecureTextEntry = true
        return txtField
    }()
    let firstNameTextField = UITextField.getTextField(Strings.firstNamePlaceholder)
    let lastNameTextField = UITextField.getTextField(Strings.lastNamePlaceholder)
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.signUp, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 24)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let agreeWithTermsLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.acceptTermsAndConditions
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        return label
    }()
    
    let termsAndConditionsButton : UIButton = {
        let button = UIButton()
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 12)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: Strings.termsAndConditions,
                                                        attributes: stringAtt)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    let errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        addSubview(textFieldStackView)
        addSubview(termsStackView)
        
        //TermsAndCondition Constraints
        termsStackView.translatesAutoresizingMaskIntoConstraints = false
        termsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant:-10).isActive = true
        termsStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        termsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        termsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setConstraints(){
        
        //TextFieldStackView Constraints
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:40).isActive = true
        textFieldStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        textFieldStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        textFieldStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        //Textfield Constraints
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        reEnterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        reEnterPasswordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        //Signup Constraints
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
    }
}
