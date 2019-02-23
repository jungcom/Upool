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
    let passwordTextField : UITextField = {
        let txtField = UITextField.getTextField(Strings.passwordPlaceholder)
        txtField.isSecureTextEntry = true
        return txtField
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
    
    let umassBackgroundImageView : UIImageView = {
        let image = UIImage(named: Images.umassBackgroundImage)
        //let image = UIImage(named: "BackGround")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleLogin(){
        
        let email = emailTextField.text
        let password = passwordTextField.text

        guard email != "" && password != "" else{
            self.errorLabel.text = "Empty email/password field"
            return
        }

        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        
//        let email : String? = "anthonylee3737@gmail.com"
//        let password : String? = "123123"
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (authResult, error) in

            guard let _ = authResult else {

                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        print("The error is \(error.localizedDescription)")
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
                    self.stopAnimating()
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            guard self.authUser?.isEmailVerified == true else {
                self.errorLabel.text = "Account not verified. Please check your email for verification"
                self.stopAnimating()
                return
            }
            
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

