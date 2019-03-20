//
//  SignUpViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/23/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import NVActivityIndicatorView

class SignUpViewController: UIViewController , NVActivityIndicatorViewable{

    let db = Firestore.firestore()
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    //Setup View
    lazy var signUpView : SignUpView = {
        let signUpView = SignUpView()
        signUpView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        signUpView.addGestureRecognizer(tap)
        return signUpView
    }()
    
    override func loadView() {
        signUpView.termsAndConditionsButton.addTarget(self, action: #selector(handleTermsAndConditions), for: .touchUpInside)
        view = signUpView
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
    
    @objc func handleCancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTermsAndConditions(){
        let termsAndConditionsVC = TermsAndConditionsViewController()
        navigationController?.pushViewController(termsAndConditionsVC, animated: true)
    }
    
    @objc func handleSignUp(){
        print("signUp")
        //for Testing
        //pushEmailSentVC()
        
        guard let email = signUpView.email ,let password = signUpView.passwordTextField.text ,let rePassword = signUpView.reEnterPasswordTextField.text,let firstName = signUpView.firstNameTextField.text,let lastName = signUpView.lastNameTextField.text, allFieldsFull() else {
            self.signUpView.errorLabel.text = "All fields must be full"
            return
        }

        guard password == rePassword else {
            self.signUpView.errorLabel.text = "Passwords do not match"
            return
        }

        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authDataResult, error) in
            guard let authDataResult = authDataResult else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        switch (errCode){
                        case .missingEmail:
                            self.signUpView.errorLabel.text = "An email address must be provided"
                        case .invalidEmail:
                            self.signUpView.errorLabel.text = "Invalid email"
                        case .emailAlreadyInUse:
                            self.signUpView.errorLabel.text = "Email already in use"
                        case .weakPassword:
                            self.signUpView.errorLabel.text = "Password is weak. Try a longer password"
                        default:
                            self.signUpView.errorLabel.text = "An error has occured. Please try again"
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                }
                self.stopAnimating()
                return
            }

            // if successful add user
            
            //get FCM Token First
            guard let fcmToken = Messaging.messaging().fcmToken else {return}
            
            let newUser = UPoolUser(email: email, fn: firstName, ln: lastName, uid: authDataResult.user.uid, fcmToken: fcmToken)
            print(newUser)
            //Add user to the Firebase database
            self.db.collection(FirebaseDatabaseKeys.usersKey).document(authDataResult.user.uid).setData(newUser.dictionary, completion: { (err) in
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
        stopAnimating()
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    private func allFieldsFull() -> Bool{
        if signUpView.passwordTextField.text == ""{
            return false
        } else if signUpView.reEnterPasswordTextField.text == ""{
            return false
        } else if signUpView.firstNameTextField.text == ""{
            return false
        } else if signUpView.lastNameTextField.text == ""{
            return false
        } else {
            return true
        }
    }
}
