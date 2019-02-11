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

    let db = Firestore.firestore()
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
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
    let firstNameTextField = UITextField.getTextField(Strings.firstNamePlaceholder)
    let lastNameTextField = UITextField.getTextField(Strings.lastNamePlaceholder)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setNavigationBar()
        setStackViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleCancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        print("signUp")
        //for Testing
        //pushEmailSentVC()
        
        guard let email = emailTextField.text ,let password = passwordTextField.text ,let rePassword = reEnterPasswordTextField.text,let firstName = firstNameTextField.text,let lastName = lastNameTextField.text, allFieldsFull() else {
            self.errorLabel.text = "All fields must be full"
            return
        }

        guard password == rePassword else {
            self.errorLabel.text = "Passwords do not match"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (authDataResult, error) in
            guard let authDataResult = authDataResult else {
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
            let newUser = UPoolUser(email: email, fn: firstName, ln: lastName, uid: authDataResult.user.uid)
            print(newUser)
            //Add user to the Firebase database
            self.db.collection("users").document(authDataResult.user.uid).setData(newUser.dictionary, completion: { (err) in
                if let _ = err{
                    print("User was not added successfully to the database")
                } else {
                    print("User was added successfully to the database!")
                }
            })
            self.sendVerificationMail()
            self.pushEmailSentVC()
        })
    }
    
    private func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                if let error = error{
                    print("\(error.localizedDescription)")
                } else {
                    print("sendEmailVerification Successful!")
                }
            })
        } else {
            // Either the user is not available, or the user is already verified.
        }
    }
    
    private func pushEmailSentVC(){
        let emailVC = EmailSentViewController()
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    private func allFieldsFull() -> Bool{
        if emailTextField.text == ""{
            return false
        } else if passwordTextField.text == ""{
            return false
        } else if reEnterPasswordTextField.text == ""{
            return false
        } else if firstNameTextField.text == ""{
            return false
        } else if lastNameTextField.text == ""{
            return false
        } else {
            return true
        }
    }
}
