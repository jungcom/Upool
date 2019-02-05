//
//  ViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit
import Firebase

class LoginViewController: UIViewController {

    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    var bottomStackView : UIStackView!
    
    let bottomContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.9
        return view
    }()
    
    let loginLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.login
        label.textAlignment = .center
        label.textColor = Colors.maroon
        label.font = UIFont(name: Fonts.helvetica, size: 32)
        label.backgroundColor = UIColor.white
        return label
    }()
    
    let emailTextField = UITextField.getTextField(Strings.emailPlaceholder)
    let passwordTextField = UITextField.getTextField(Strings.passwordPlaceholder)
    
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
    
    let umassBackgroundImageView : UIImageView = {
        let image = UIImage(named: Images.umassBackgroundImage)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.5
        return imageView
    }()
    
    let errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.red
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupStackViews()
        setupUI()
        setupConstraints()
        setupKeyboardNotifications()
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleLogin(){
        //Faster Login
//        present(LoginViewController.presentMainPage(), animated: true, completion: nil)
        
        
//        let email = emailTextField.text
//        let password = passwordTextField.text
//
//        guard email != "" && password != "" else{
//            self.errorLabel.text = "Empty email/password field"
//            return
//        }

        let email : String? = "anthonylee3737@gmail.com"
        let password : String? = "123123"
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (authResult, error) in

            guard self.authUser?.isEmailVerified == true else {
                self.errorLabel.text = "Account not verified. Please check your email for verification"
                return
            }

            guard let _ = authResult else {

                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        switch (errCode){
                        case .userNotFound:
                            self.errorLabel.text = "User account not found"
                        case .wrongPassword:
                            self.errorLabel.text = "Incorrect password"
                        case .invalidEmail:
                            self.errorLabel.text = "Invalid email"
                        default:
                            self.errorLabel.text = "An error has occured. Please try again"
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                }
                return
            }

            self.present(LoginViewController.presentMainPage(), animated: true, completion: nil)
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
        let signUpVC = SignUpViewController()
        let navVC = UINavigationController(rootViewController: signUpVC)
        present(navVC, animated: true, completion: nil)
    }
    
    static func presentMainPage() -> UIViewController{
        let ridesVC = OfferedRidesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        ridesVC.tabBarItem = UITabBarItem(title: "Rides", image: UIImage(named: "RideIcon"), tag: 0)
        let statusVC = MyStatusViewController(collectionViewLayout: UICollectionViewFlowLayout())
        statusVC.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: "StatusLogo"), tag: 1)
        
        let tabBarController = UITabBarController()
        let controllers = [ridesVC, statusVC]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.tintColor = Colors.maroon
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        return tabBarController
    }
}

