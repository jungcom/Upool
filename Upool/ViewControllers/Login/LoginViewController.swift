//
//  ViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController, NVActivityIndicatorViewable {

    lazy var db = Firestore.firestore()
    
    var signedIn : Bool = false {
        didSet{
            if signedIn{
                print("present")
                startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
                self.present(LoginViewController.presentMainPage(), animated: true, completion: {
                    self.stopAnimating()
                    //fix bug where observer won't be removed when autosigning in
                    NotificationCenter.default.removeObserver(self)
                })
            }
        }
    }
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    // Set Up View
    let loginView : LoginView = {
        let loginView = LoginView()
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.forgotPwdButton.addTarget(self, action: #selector(handleForgottenPwd), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return loginView
    }()
    
    override func loadView() {
        view = loginView
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleLogin(){
        
        let email = loginView.emailTextField.text
        let password = loginView.passwordTextField.text

        guard email != "" && password != "" else{
            self.loginView.errorLabel.text = "Empty email/password field"
            return
        }

        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (authResult, error) in

            guard let authResult = authResult else {

                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        print("The error is \(error.localizedDescription)")
                        switch (errCode){
                        case .userNotFound:
                            self.loginView.errorLabel.text = "User account not found"
                        case .wrongPassword:
                            self.loginView.errorLabel.text = "Incorrect password"
                        case .invalidEmail:
                            self.loginView.errorLabel.text = "Invalid email"
                        default:
                            self.loginView.errorLabel.text = "An error has occured. Please try again"
                        }
                    }
                    self.stopAnimating()
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            guard self.authUser?.isEmailVerified == true else {
                self.loginView.errorLabel.text = "Account not verified. Please check your email for verification"
                self.stopAnimating()
                return
            }
            
            //Update user's fcmToken to this Device
            let noFcmToken = [FirebaseDatabaseKeys.UserFieldKeys.fcmToken: AppDelegate.DEVICE_FCM_TOKEN]
            self.db.collection(FirebaseDatabaseKeys.usersKey).document(authResult.user.uid).updateData(noFcmToken)
            
            self.present(LoginViewController.presentMainPage(), animated: true, completion: {
                self.stopAnimating()
            })
        })
        
    }

    @objc func handleForgottenPwd(){
        print("no password")
        let passwordResetVC = ResetPasswordViewController()
        let navVC = UINavigationController(rootViewController: passwordResetVC)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        print("SignUp")
        let signUpVC = SignUpEmailViewController()
        let navVC = UINavigationController(rootViewController: signUpVC)
        present(navVC, animated: true, completion: nil)
    }
    
    static func presentMainPage() -> UIViewController{
        let ridesVC = OfferedRidesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        ridesVC.tabBarItem = UITabBarItem(title: "All Rides", image: UIImage(named: "RideIcon"), tag: 0)
        let statusVC = MyStatusViewController(collectionViewLayout: UICollectionViewFlowLayout())
        statusVC.tabBarItem = UITabBarItem(title: "My Rides", image: UIImage(named: "StatusLogo"), tag: 1)
        let chatVC = ChatViewController()
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "ChatIcon"), tag: 2)
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ProfileIcon"), tag: 3)

        
        let tabBarController = UITabBarController()
        let controllers = [ridesVC, statusVC, chatVC, profileVC]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.tintColor = Colors.maroon
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        return tabBarController
    }
}

//Textfield Notifications
extension LoginViewController{
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Login Keyboard will show")
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

