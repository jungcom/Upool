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
    
    let blackView : UIView = {
        let black = UIView()
        black.backgroundColor = UIColor(white: 0, alpha: 0.5)
        black.alpha = 0
        return black
    }()
    
    let dateButton : UIButton = {
        let button = UIButton()
        button.setTitle("Date", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.addTarget(self, action: #selector(handleCalendarView), for: .touchUpInside)
        return button
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
        cv.setDisplayDate(Date())
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
    
    @objc func handleCalendarRight(){
        calendarView.goToNextMonth()
    }
    
    @objc func handleCalendarLeft(){
        calendarView.goToPreviousMonth()
    }
    
}
