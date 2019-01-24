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
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        print("signUp")
        let ridesVC = OfferedRidesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let navigationVC = UINavigationController(rootViewController: ridesVC)
        present(navigationVC, animated: true, completion: nil)
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
