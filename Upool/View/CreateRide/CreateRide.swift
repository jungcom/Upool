//
//  CreateRide.swift
//  Upool
//
//  Created by Anthony Lee on 1/28/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import KDCalendar

extension CreateRideViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Create Ride"
        calendarView.dataSource = self
        calendarView.delegate = self
        
        setupDateTimeButtons()
        setupToFromButtons()
        setupPriceLabelAndSlider()
        setupPassengerLabelCosmosView()
        setupPickUpDetailsView()
        setupCreateButton()
        
    }
    
    func setupDateTimeButtons(){
        
        dateTimeStack = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        dateTimeStack.axis = .horizontal
        dateTimeStack.alignment = .center
        dateTimeStack.distribution = .fillEqually
        dateTimeStack.spacing = 30
                
        view.addSubview(dateTimeStack)
        
        dateTimeStack.translatesAutoresizingMaskIntoConstraints = false
        dateTimeStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateTimeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        dateTimeStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        dateTimeStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        //UnderlineViews and Constraints
        let bottomBorderViewForDate = UIView()
        let bottomBorderViewForTime = UIView()
        
        view.addSubview(bottomBorderViewForDate)
        view.addSubview(bottomBorderViewForTime)
        
        bottomBorderViewForDate.addGrayBottomBorder(view: dateLabel, multiplier: 1)
        bottomBorderViewForTime.addGrayBottomBorder(view: timeLabel, multiplier: 1)
        
    }
    
    func setupToFromButtons(){
        fromToStack = UIStackView(arrangedSubviews: [fromLabel, toLabel])
        fromToStack.axis = .vertical
        fromToStack.alignment = .fill
        fromToStack.distribution = .equalSpacing
        
        view.addSubview(fromToStack)
        
        fromToStack.translatesAutoresizingMaskIntoConstraints = false
        fromToStack.topAnchor.constraint(equalTo: dateTimeStack.bottomAnchor, constant: 10).isActive = true
        fromToStack.leadingAnchor.constraint(equalTo: dateTimeStack.leadingAnchor).isActive = true
        fromToStack.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 1).isActive = true
        fromToStack.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 1).isActive = true
        
        //UnderlineViews and Constraints
        let bottomBorderViewFrom = UIView()
        let bottomBorderViewTo = UIView()
        
        view.addSubview(bottomBorderViewFrom)
        view.addSubview(bottomBorderViewTo)
        
        bottomBorderViewFrom.addGrayBottomBorder(view: fromLabel, multiplier: 1)
        bottomBorderViewTo.addGrayBottomBorder(view: toLabel, multiplier: 1)
    }
    
    func setupPriceLabelAndSlider(){
        priceStack = UIStackView(arrangedSubviews: [priceLabel, priceSlider, dollarLabel])
        priceStack.axis = .horizontal
        priceStack.distribution = .fill
        priceStack.alignment = .center
        priceStack.spacing = 50
        
        view.addSubview(priceStack)
        
        priceStack.translatesAutoresizingMaskIntoConstraints = false
        priceStack.topAnchor.constraint(equalTo: fromToStack.bottomAnchor, constant: 10).isActive = true
        priceStack.leadingAnchor.constraint(equalTo: dateTimeStack.leadingAnchor).isActive = true
        priceStack.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 1).isActive = true
        priceStack.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setupPassengerLabelCosmosView(){
        passengerStack = UIStackView(arrangedSubviews: [passengerLabel, passengerCosmosView])
        passengerStack.axis = .horizontal
        passengerStack.distribution = .fillProportionally
        passengerStack.alignment = .leading
        passengerStack.spacing = 50
        
        view.addSubview(passengerStack)
        
        passengerStack.translatesAutoresizingMaskIntoConstraints = false
        passengerStack.topAnchor.constraint(equalTo: priceStack.bottomAnchor, constant: 10).isActive = true
        passengerStack.leadingAnchor.constraint(equalTo: dateTimeStack.leadingAnchor).isActive = true
        passengerStack.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 1).isActive = true
        passengerStack.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    func setupPickUpDetailsView(){
        view.addSubview(pickupDetailsLabel)
        view.addSubview(pickupDetailsTextView)
        
        pickupDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        pickupDetailsLabel.topAnchor.constraint(equalTo: passengerStack.bottomAnchor, constant: 10).isActive = true
        pickupDetailsLabel.leadingAnchor.constraint(equalTo: dateTimeStack.leadingAnchor).isActive = true
        pickupDetailsLabel.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 0.5).isActive = true
        pickupDetailsLabel.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 0.3).isActive = true
        
        pickupDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        pickupDetailsTextView.topAnchor.constraint(equalTo: pickupDetailsLabel.bottomAnchor, constant: 10).isActive = true
        pickupDetailsTextView.leadingAnchor.constraint(equalTo: dateTimeStack.leadingAnchor).isActive = true
        pickupDetailsTextView.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 1).isActive = true
        pickupDetailsTextView.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 1.5).isActive = true
    }
    
    func setupCreateButton(){
        view.addSubview(createRideButton)
        
        createRideButton.translatesAutoresizingMaskIntoConstraints = false
        createRideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        createRideButton.trailingAnchor.constraint(equalTo: dateTimeStack.trailingAnchor).isActive = true
        createRideButton.widthAnchor.constraint(equalTo: dateTimeStack.widthAnchor, multiplier: 0.4).isActive = true
        createRideButton.heightAnchor.constraint(equalTo: dateTimeStack.heightAnchor, multiplier: 0.5).isActive = true
    }
}

//Textfield Notifications

extension CreateRideViewController {
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
