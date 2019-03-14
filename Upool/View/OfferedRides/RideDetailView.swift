//
//  RideDetailView.swift
//  Upool
//
//  Created by Anthony Lee on 3/8/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
class RideDetailView : UIView{
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: 0, height: 800)
        scrollView.backgroundColor = UIColor.groupTableViewBackground
        return scrollView
    }()
    
    let topContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // First Top View
    let firstTopView = UIView()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    lazy var departureCityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    let rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        imageView.tintColor = Colors.maroon
        return imageView
    }()
    
    lazy var destinationCityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    var locationStackView : UIStackView!
    
    lazy var passengerSeatsLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //Second Top View
    let secondTopView = UIView()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.backgroundColor = UIColor.gray
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(named: "ProfileImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Robinson Crusoe"
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    let driverInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "Payment in Cash"
        label.font = UIFont(name: Fonts.futura, size: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.moneyGreen
        return label
    }()
    
    //Third Top View
    let thirdTopView = UIView()
    
    let pickUpLabel : UILabel = {
        let label = UILabel()
        label.text = "Pickup/Dropoff Details"
        label.font = UIFont(name: Fonts.futura, size: 17)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var pickupDetailTextView : UITextView = {
        let label = UITextView()
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        label.isEditable = false
        label.isScrollEnabled = false
        return label
    }()
    
    //Fourth Top view
    let buttonView = UIView()
    
    var buttonStackView : UIStackView!
    
    let messageButton : UIButton = {
        let button = UIButton()
        button.setTitle("MESSAGE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    let joinRideButton : UIButton = {
        let button = UIButton()
        button.setTitle("JOIN RIDE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 17)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    //Bottom Container
    
    let bottomContainer = UIView()
    
    //Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(scrollView)
        setupScrollView()
        setupTopContainer()
        setupFirstTopView()
        setupSecondTopView()
        setupThirdTopView()
        setupButtonStackView()
        
        //bottom container
        setupBottomContainer()
    }
    
    func setupScrollView(){
        scrollView.addSubview(topContainer)
        UIView.dropShadow(view: topContainer)
        scrollView.addSubview(bottomContainer)
        scrollView.contentSize = CGSize(width: frame.width, height: 800)
        scrollView.backgroundColor = UIColor.groupTableViewBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupTopContainer(){
        topContainer.addSubview(firstTopView)
        topContainer.addSubview(secondTopView)
        topContainer.addSubview(thirdTopView)
        topContainer.addSubview(buttonView)
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        topContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupFirstTopView(){
        locationStackView = UIStackView(arrangedSubviews: [departureCityLabel, rightArrowIconImageView, destinationCityLabel])
        locationStackView.axis = .horizontal
        locationStackView.distribution = .equalCentering
        locationStackView.alignment = .center
        
        firstTopView.addSubview(dateLabel)
        firstTopView.addSubview(locationStackView)
        firstTopView.addSubview(passengerSeatsLabel)
        
        //MARK : First Top View Constraints
        firstTopView.translatesAutoresizingMaskIntoConstraints = false
        firstTopView.topAnchor.constraint(equalTo: topContainer.topAnchor).isActive = true
        firstTopView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        firstTopView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        firstTopView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        
        //dateLabel Constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: firstTopView.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: firstTopView.leadingAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: firstTopView.widthAnchor, multiplier: 0.7).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: firstTopView.heightAnchor, multiplier: 0.4).isActive = true
        
        //Passenger Count Label Constraints
        passengerSeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerSeatsLabel.topAnchor.constraint(equalTo: firstTopView.topAnchor, constant: 5).isActive = true
        passengerSeatsLabel.trailingAnchor.constraint(equalTo: firstTopView.trailingAnchor, constant: -5).isActive = true
        passengerSeatsLabel.widthAnchor.constraint(equalTo: firstTopView.widthAnchor, multiplier: 0.3).isActive = true
        
        //location View Constraints
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.centerXAnchor.constraint(equalTo: firstTopView.centerXAnchor).isActive = true
        locationStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant:0).isActive = true
        locationStackView.widthAnchor.constraint(equalTo: firstTopView.widthAnchor, multiplier: 0.8).isActive = true
        locationStackView.heightAnchor.constraint(equalTo: firstTopView.heightAnchor, multiplier: 0.5).isActive = true
        
        //Bottom border view and Constraints
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = UIColor.gray
        firstTopView.addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.bottomAnchor.constraint(equalTo: firstTopView.bottomAnchor).isActive = true
        bottomBorderView.widthAnchor.constraint(equalTo: locationStackView.widthAnchor, multiplier: 1.0).isActive = true
        bottomBorderView.centerXAnchor.constraint(equalTo: firstTopView.centerXAnchor).isActive = true
        bottomBorderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupSecondTopView(){
        secondTopView.addSubview(profileImageView)
        secondTopView.addSubview(nameLabel)
        secondTopView.addSubview(driverInfoLabel)
        secondTopView.addSubview(priceLabel)
        
        //MARK : Second Top View Constraints
        secondTopView.translatesAutoresizingMaskIntoConstraints = false
        secondTopView.topAnchor.constraint(equalTo: firstTopView.bottomAnchor).isActive = true
        secondTopView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        secondTopView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        secondTopView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        
        //ProfileImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 5).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: secondTopView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: secondTopView.heightAnchor, multiplier: 0.6).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        //Name Label Constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        
        //Driver Info Label Constraints
        driverInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        driverInfoLabel.centerYAnchor.constraint(equalTo: secondTopView.centerYAnchor, constant:5).isActive = true
        driverInfoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 15).isActive = true
        driverInfoLabel.widthAnchor.constraint(equalTo: secondTopView.widthAnchor, multiplier:  0.5).isActive = true
        
        //PricelLabel Constraints
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerYAnchor.constraint(equalTo: secondTopView.centerYAnchor, constant:5).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: secondTopView.trailingAnchor, constant: -20).isActive = true
        
        //BottomBorder Contraints
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = UIColor.gray
        firstTopView.addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.bottomAnchor.constraint(equalTo: secondTopView.bottomAnchor).isActive = true
        bottomBorderView.widthAnchor.constraint(equalTo: locationStackView.widthAnchor, multiplier: 1.0).isActive = true
        bottomBorderView.centerXAnchor.constraint(equalTo: secondTopView.centerXAnchor).isActive = true
        bottomBorderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupThirdTopView(){
        thirdTopView.addSubview(pickUpLabel)
        thirdTopView.addSubview(pickupDetailTextView)
        
        //MARK : Thrid Top View Constraints
        thirdTopView.translatesAutoresizingMaskIntoConstraints = false
        thirdTopView.topAnchor.constraint(equalTo: secondTopView.bottomAnchor).isActive = true
        thirdTopView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        thirdTopView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        thirdTopView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        
        //PickUp Label Constraints
        pickUpLabel.translatesAutoresizingMaskIntoConstraints = false
        pickUpLabel.leadingAnchor.constraint(equalTo: locationStackView.leadingAnchor).isActive = true
        pickUpLabel.topAnchor.constraint(equalTo: thirdTopView.topAnchor, constant: 20).isActive = true
        
        //PickUp Detail TextView Constraints
        pickupDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        pickupDetailTextView.topAnchor.constraint(equalTo: pickUpLabel.bottomAnchor, constant: 5).isActive = true
        pickupDetailTextView.centerXAnchor.constraint(equalTo: thirdTopView.centerXAnchor).isActive = true
        pickupDetailTextView.widthAnchor.constraint(equalTo: thirdTopView.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func setupButtonStackView(){
        buttonStackView = UIStackView(arrangedSubviews: [messageButton, joinRideButton])
        buttonStackView.alignment = .center
        buttonStackView.spacing = 15
        buttonStackView.distribution = .fillEqually
        
        buttonView.addSubview(buttonStackView)
        
        //MARK :ButtonView Constraints
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.topAnchor.constraint(equalTo: thirdTopView.bottomAnchor).isActive = true
        buttonView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        
        //buttonStackView Constraints
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
        buttonStackView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.6).isActive = true
        buttonStackView.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupBottomContainer(){
        bottomContainer.backgroundColor = UIColor.groupTableViewBackground
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10).isActive = true
        bottomContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bottomContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier:1.0).isActive = true
    }
}
