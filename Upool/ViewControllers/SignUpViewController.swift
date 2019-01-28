//
//  SignUpViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/23/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

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
    
    let errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.red
        label.text = "This is an error message"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setNavigationBar()
        setStackViews()
        setConstraints()
        setupKeyboardNotifications()
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        print("signUp")
        let email = emailTextField.text
        let password = passwordTextField.text
        let rePassword = reEnterPasswordTextField.text
        
        guard password == rePassword else {
            self.errorLabel.text = "Passwords do not match"
            return
        }
        
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        switch (errCode){
                        case .missingEmail:
                            self.errorLabel.text = "An email address must be provided"
                        case .invalidEmail:
                            self.errorLabel.text = "Invalid email"
                        case .emailAlreadyInUse:
                            self.errorLabel.text = "Email already in use"
                        case .weakPassword:
                            self.errorLabel.text = "Password is weak. Try a longer password"
                        default:
                            self.errorLabel.text = "An error has occured. Please try again"
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            // if successful add user
            
            //Add user to the Firebase database
//            if let uid = Auth.auth().currentUser?.uid{
//                let ref = Database.database().reference()
//                let userRef = ref.child("users").child(uid)
//                var values = ["firstName": self.firstNameTextField.text, "lastName":self.lastNameTextField.text, "email":email]
//                values["uid"] = uid
//                userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                    if err != nil{
//                        print(err?.localizedDescription)
//                        return
//                    }
//                    print("Saved user data to DB")
//                })
//
//                self.signInTo()
//            }
            
            self.present(LoginViewController.presentMainPage(), animated: true, completion: nil)
        })
    }
    
}
