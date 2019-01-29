//
//  CreateRideViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import KDCalendar

class CreateRideViewController: UIViewController {

    let formatter = DateFormatter()
    
    var dateTimeStack : UIStackView!
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCalendarView)))
        return label
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClockView)))
        return label
    }()
    
    //CalendarView
    let blackView : UIView = {
        let black = UIView()
        black.backgroundColor = UIColor(white: 0, alpha: 0.5)
        black.alpha = 0
        return black
    }()
    
    let leftButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.leftArrow), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    let rightButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.rightArrow), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    let calendarView : CalendarView = {
        let cv = CalendarView()
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.dataSource = self
        calendarView.delegate = self
        setupUI()
        
    }
    
    //Calendar View
    @objc func handleCalendarView(){
        setupCalendarView()
    }
    
    @objc func handleClockView(){
        
    }
    
    @objc func handleCalendarRight(){
        calendarView.goToNextMonth()
    }
    
    @objc func handleCalendarLeft(){
        calendarView.goToPreviousMonth()
    }
    
}
