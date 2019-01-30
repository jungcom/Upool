//
//  CreateRideDatePickerView.swift
//  Upool
//
//  Created by Anthony Lee on 1/30/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension CreateRideViewController {
    func setupTimePicker() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissTimePickerView)))
            window.addSubview(blackView)
            window.addSubview(timePicker)
            
            //TimePicker setup
            timePicker.backgroundColor = UIColor.white
            timePicker.datePickerMode = .time
            timePicker.minuteInterval = 15
            //timePicker.setValue(UIColor.white, forKey: "textColor")
            
            //TimePicker Constraints
            timePicker.translatesAutoresizingMaskIntoConstraints = false
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            timePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.7).isActive = true
            timePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4).isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.timePicker.alpha = 1
            }
        }
    }
    
    @objc func handleDismissTimePickerView(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.timePicker.alpha = 0
        }
    }
}
