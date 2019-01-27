//
//  ViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
        print("login")
        present(LoginViewController.presentMainPage(), animated: true, completion: nil)    }

    @objc func handleForgottenPwd(){
        print("no password")
        
    }
    
    @objc func handleSignUp(){
        print("SignUp")
        let signUpVC = SignUpViewController()
        present(signUpVC, animated: true, completion: nil)
    }
    
    static func presentMainPage() -> UIViewController{
        let ridesVC = OfferedRidesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        ridesVC.tabBarItem = UITabBarItem(title: "Rides", image: UIImage(named: "right-arrow"), tag: 0)
        let downloadsVC = UIViewController()
        downloadsVC.title = "Downloads"
        downloadsVC.view.backgroundColor = UIColor.blue
        downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let tabBarController = UITabBarController()
        let controllers = [ridesVC, downloadsVC]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.tintColor = Colors.maroon
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        return tabBarController
    }

}

