//
//  CreateRideViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CreateRideViewController: UIViewController {

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
    
    let calendarView : JTAppleCalendarView = {
        let cv = JTAppleCalendarView()
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    //Calendar View
    @objc func handleCalendarView(){
        setupCalendarView()
        
    }
}
