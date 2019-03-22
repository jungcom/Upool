//
//  ProfileView.swift
//  Upool
//
//  Created by Anthony Lee on 3/6/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class ProfileView: UIView{
    var thisUser : UPoolUser? {
        didSet{
            guard let thisUser = thisUser else {return}
            if let url = thisUser.profileImageUrl{
                profileImageView.loadImageUsingCacheWithUrlString(url)
                profileImageView.clipsToBounds = true
                profileImageView.layer.cornerRadius = 30
                profileImageViewShadow.layer.cornerRadius = 30
            }
            self.nameLabel.text = "\(thisUser.firstName ?? "") \(thisUser.lastName ?? "" )"
            self.userFirstName.subjectTextField.text = "\(thisUser.firstName ?? "" )"
            self.userLastName.subjectTextField.text = "\(thisUser.lastName ?? "" )"
            self.userGradYear.subjectTextField.text = "\(thisUser.gradYear ?? "" )"
            self.userMajor.subjectTextField.text = "\(thisUser.major ?? "" )"
            self.userAge.subjectTextField.text = "\(thisUser.age ?? "" )"

        }
    }
    
    //MARK : UI Properties
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize.height = 800
        return scrollView
    }()
    
    //TopProfileImageContainer
    let profileImageAndNameContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "AddProfileImage")
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var profileImageViewShadow : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        UIView.dropShadow(view: view)
        return view
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = Colors.maroon
        label.font = UIFont(name: Fonts.helvetica, size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //Container About the User
    let aboutContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    let aboutLabel : UILabel = {
        let label = UILabel()
        label.text = "About"
        label.textColor = UIColor.gray
        label.font = UIFont.init(name: Fonts.helvetica, size: 20)
        return label
    }()
    
    let pencilEditButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PencilEdit"), for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        return button
    }()
    
    //StackView for UserInfo
    
    let userInfoUIView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        UIView.dropShadow(view: view)
        return view
    }()
    
    var userInfoStackView : UIStackView!
    
    let userFirstName : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "First Name"
        userInfo.subjectTextField.placeholder = "First Name"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userLastName : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Last Name"
        userInfo.subjectTextField.placeholder = "Last Name"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userGradYear : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Grad Year"
        userInfo.subjectTextField.placeholder = "Your Graduation Year"
        userInfo.isUserInteractionEnabled = false
        userInfo.subjectTextField.keyboardType = .numberPad
        return userInfo
    }()
    
    let userMajor : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Major"
        userInfo.subjectTextField.placeholder = "Major"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userAge : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Age"
        userInfo.subjectTextField.placeholder = "Age"
        userInfo.isUserInteractionEnabled = false
        userInfo.subjectTextField.keyboardType = .numberPad
        return userInfo
    }()
    // My Car
    let myCarButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SmallRightArrow"), for: .normal)
        button.imageView?.tintColor = Colors.maroon
        button.imageView?.contentMode = .right
        button.setTitle("My Car", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.futuraMedium, size: 18)
        button.backgroundColor = UIColor.white
        UIView.dropShadow(view: button)
        return button
    }()
    
    //Settings Container
    
    let settingsButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SmallRightArrow"), for: .normal)
        button.imageView?.tintColor = Colors.maroon
        button.imageView?.contentMode = .right
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.futuraMedium, size: 18)
        button.backgroundColor = UIColor.white
        UIView.dropShadow(view: button)
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        setupScrollBar()
        setupProfileImageAndNameContainer()
        setupAboutContainer()
        setupUserInfoStackView()
        setupMyCarButton()
        setupSettingsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollBar(){
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupProfileImageAndNameContainer(){
        scrollView.addSubview(profileImageAndNameContainer)
        profileImageAndNameContainer.translatesAutoresizingMaskIntoConstraints = false
        profileImageAndNameContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profileImageAndNameContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageAndNameContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        profileImageAndNameContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier:0.35).isActive = true
        
        profileImageAndNameContainer.addSubview(profileImageViewShadow)
        profileImageAndNameContainer.addSubview(profileImageView)
        profileImageAndNameContainer.addSubview(nameLabel)
        
        //ProfileImageView Constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: profileImageAndNameContainer.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: profileImageAndNameContainer.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageAndNameContainer.widthAnchor, multiplier: 0.3).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        //ImageShadowView Constraints
        profileImageViewShadow.translatesAutoresizingMaskIntoConstraints = false
        profileImageViewShadow.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant:0).isActive = true
        profileImageViewShadow.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant:0).isActive = true
        profileImageViewShadow.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant:0).isActive = true
        profileImageViewShadow.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant:0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupAboutContainer(){
        //Add Subviews
        scrollView.addSubview(aboutContainerView)
        aboutContainerView.addSubview(aboutLabel)
        aboutContainerView.addSubview(pencilEditButton)
        aboutContainerView.addSubview(userInfoUIView)
        
        aboutContainerView.translatesAutoresizingMaskIntoConstraints = false
        aboutContainerView.topAnchor.constraint(equalTo: profileImageAndNameContainer.bottomAnchor).isActive = true
        aboutContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        aboutContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        aboutContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        //About Label
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.topAnchor.constraint(equalTo: aboutContainerView.topAnchor).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor, constant:20).isActive = true
        
        //Pencil Edit Button Constraints
        pencilEditButton.translatesAutoresizingMaskIntoConstraints = false
        pencilEditButton.bottomAnchor.constraint(equalTo: aboutLabel.bottomAnchor)
        pencilEditButton.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor, constant:-20).isActive = true
        pencilEditButton.heightAnchor.constraint(equalTo: aboutLabel.heightAnchor).isActive = true
        pencilEditButton.widthAnchor.constraint(equalTo: pencilEditButton.heightAnchor).isActive = true
        
        
        //UserInfo UIView
        userInfoUIView.translatesAutoresizingMaskIntoConstraints = false
        userInfoUIView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant:5).isActive = true
        userInfoUIView.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor).isActive = true
        userInfoUIView.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor, constant:-20).isActive = true
        userInfoUIView.heightAnchor.constraint(equalTo: aboutContainerView.heightAnchor, multiplier:0.4).isActive = true
        
        //setup user info stack View
        setupUserInfoStackView()
    }
    
    func setupUserInfoStackView(){
        userInfoStackView = UIStackView(arrangedSubviews: [userFirstName, userLastName, userGradYear, userMajor, userAge])
        userInfoStackView.axis = .vertical
        userInfoStackView.distribution = .equalSpacing
        
        userInfoUIView.addSubview(userInfoStackView)
        
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.topAnchor.constraint(equalTo: userInfoUIView.topAnchor, constant:5).isActive = true
        userInfoStackView.leadingAnchor.constraint(equalTo: userInfoUIView.leadingAnchor, constant:5).isActive = true
        userInfoStackView.trailingAnchor.constraint(equalTo: userInfoUIView.trailingAnchor, constant:-5).isActive = true
        userInfoStackView.bottomAnchor.constraint(equalTo: userInfoUIView.bottomAnchor, constant:-5).isActive = true
    }
    
    func setupMyCarButton(){
        scrollView.addSubview(myCarButton)
        
        myCarButton.translatesAutoresizingMaskIntoConstraints = false
        myCarButton.topAnchor.constraint(equalTo: userInfoUIView.bottomAnchor, constant:30).isActive = true
        myCarButton.leadingAnchor.constraint(equalTo: userInfoUIView.leadingAnchor).isActive = true
        myCarButton.trailingAnchor.constraint(equalTo: userInfoUIView.trailingAnchor).isActive = true
        myCarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        myCarButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        myCarButton.imageView?.centerYAnchor.constraint(equalTo: myCarButton.centerYAnchor).isActive = true
        myCarButton.imageView?.trailingAnchor.constraint(equalTo: myCarButton.trailingAnchor, constant: -20).isActive = true
        
        myCarButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        myCarButton.titleLabel?.leadingAnchor.constraint(equalTo: myCarButton.leadingAnchor, constant: 15).isActive = true
        myCarButton.titleLabel?.centerYAnchor.constraint(equalTo: myCarButton.centerYAnchor).isActive = true
    }
    
    func setupSettingsView(){
        scrollView.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: myCarButton.bottomAnchor, constant:30).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: userInfoUIView.leadingAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: userInfoUIView.trailingAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        settingsButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.imageView?.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor).isActive = true
        settingsButton.imageView?.trailingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: -20).isActive = true
        
        settingsButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.titleLabel?.leadingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: 15).isActive = true
        settingsButton.titleLabel?.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor).isActive = true
    }
}
