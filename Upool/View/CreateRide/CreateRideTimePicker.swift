//
//  CreateRideDatePickerView.swift
//  Upool
//
//  Created by Anthony Lee on 1/30/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension CreateRideViewController {
    //Whole View
    func setupTimePickerWholeView(){
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissTimePicker)))
            window.addSubview(blackView)
            window.addSubview(timePickerPopupView)
            
            //TimePickerPopupView Constraints
            timePickerPopupView.translatesAutoresizingMaskIntoConstraints = false
            timePickerPopupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            timePickerPopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            timePickerPopupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.7).isActive = true
            timePickerPopupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4).isActive = true
            
            setupTimePickerView()
            setupOkAndCancelButtonsForTimePicker()
            
            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.timePickerPopupView.alpha = 1
            }
        }
    }
    
    fileprivate func setupTimePickerView() {
        timePickerPopupView.addSubview(timePicker)
        
        //TimePicker setup
        timePicker.backgroundColor = UIColor.white
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 15
        //timePicker.setValue(UIColor.white, forKey: "textColor")
        
        //TimePicker Constraints
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.topAnchor.constraint(equalTo: timePickerPopupView.topAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: timePickerPopupView.trailingAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: timePickerPopupView.leadingAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalTo: timePickerPopupView.heightAnchor, multiplier:0.9).isActive = true
    }
    
    fileprivate func setupOkAndCancelButtonsForTimePicker(){
        timePickerPopupView.addSubview(okButtonForTimePicker)
        timePickerPopupView.addSubview(cancelButtonForTimePicker)
        
        okButtonForTimePicker.translatesAutoresizingMaskIntoConstraints = false
        okButtonForTimePicker.bottomAnchor.constraint(equalTo: timePickerPopupView.bottomAnchor, constant:-10).isActive = true
        okButtonForTimePicker.trailingAnchor.constraint(equalTo: timePickerPopupView.trailingAnchor, constant:-20).isActive = true
        
        cancelButtonForTimePicker.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonForTimePicker.bottomAnchor.constraint(equalTo: okButtonForTimePicker.bottomAnchor).isActive = true
        cancelButtonForTimePicker.trailingAnchor.constraint(equalTo: okButtonForTimePicker.leadingAnchor, constant:-30).isActive = true
    }
    
    @objc func handleOKForTimePicker(){
        departureTime = timePicker.date
        if let time = departureTime{
            timeLabel.text = timeFormatter.string(from: time)
            timeLabel.textColor = Colors.maroon
        } else {
            timeLabel.text = "Time"
            timeLabel.textColor = UIColor.gray
        }
        handleDismissTimePicker()
    }
    
    @objc func handleDismissTimePicker(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.timePickerPopupView.alpha = 0
        }
    }
}
