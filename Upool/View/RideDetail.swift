//
//  RideDetail.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension RideDetailViewController{
    
    func setupFirstTopView(){
        let locationStackView = UIStackView(arrangedSubviews: [departureCityLabel, rightArrowIconImageView, destinationCityLabel])
        locationStackView.axis = .horizontal
        locationStackView.distribution = .equalCentering
        locationStackView.alignment = .center
        
        firstTopView.addSubview(dateLabel)
        firstTopView.addSubview(locationStackView)
        firstTopView.addSubview(passengerSeatsLabel)
        
        //MARK : First Top View Constraints
        firstTopView.translatesAutoresizingMaskIntoConstraints = false
        firstTopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        firstTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        firstTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        firstTopView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        //dateLabel Constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: firstTopView.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: firstTopView.leadingAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: firstTopView.widthAnchor, multiplier: 0.5).isActive = true
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
        locationStackView.widthAnchor.constraint(equalTo: firstTopView.widthAnchor, multiplier: 0.7).isActive = true
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
//        secondTopView.backgroundColor = UIColor.blue
        
        secondTopView.addSubview(profileImageView)
        secondTopView.addSubview(nameLabel)
        
        //MARK : Second Top View Constraints
        secondTopView.translatesAutoresizingMaskIntoConstraints = false
        secondTopView.topAnchor.constraint(equalTo: firstTopView.bottomAnchor).isActive = true
        secondTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        secondTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        secondTopView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
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
        
    }
}
