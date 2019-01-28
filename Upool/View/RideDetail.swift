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
        
        //        firstTopView.backgroundColor = UIColor.blue
        
        firstTopView.addSubview(dateLabel)
        firstTopView.addSubview(locationStackView)
        firstTopView.addSubview(passengerSeatsLabel)
        
        view.addSubview(firstTopView)
        
        //Constraints
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
        bottomBorderView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
    }
    
    func setupSecondTopView(){
        
    }
}
