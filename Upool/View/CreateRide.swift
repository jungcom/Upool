//
//  CreateRide.swift
//  Upool
//
//  Created by Anthony Lee on 1/28/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension CreateRideViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Create Ride"
        
        setupDateTimeButtons()
    }
    
    func setupDateTimeButtons(){
        view.addSubview(dateButton)
        
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        dateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        dateButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
    }
    
    //
    func setupCalendarView() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissBlackView)))
            window.addSubview(calendarView)
            window.addSubview(blackView)

//            calendar Constraints
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.7).isActive = true
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4).isActive = true
            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.calendarView.alpha = 1
            }
        }
    }
    
    @objc func handleDismissBlackView(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.calendarView.alpha = 0
        }
    }
}
