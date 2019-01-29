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
        
        setupDateTimeButtons()
        
    }
    
    func setupDateTimeButtons(){
        
        dateTimeStack = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        dateTimeStack.axis = .horizontal
        dateTimeStack.alignment = .center
        dateTimeStack.distribution = .fillEqually
                
        view.addSubview(dateTimeStack)
        
        dateTimeStack.translatesAutoresizingMaskIntoConstraints = false
        dateTimeStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateTimeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        dateTimeStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        dateTimeStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        //UnderlineViews and Constraints
        let bottomBorderViewForDate = UIView()
        let bottomBorderViewForTime = UIView()

        bottomBorderViewForDate.backgroundColor = UIColor.gray
        bottomBorderViewForTime.backgroundColor = UIColor.gray

        view.addSubview(bottomBorderViewForDate)
        view.addSubview(bottomBorderViewForTime)
        
        bottomBorderViewForDate.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderViewForDate.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        bottomBorderViewForDate.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        bottomBorderViewForDate.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, multiplier: 0.9).isActive = true
        bottomBorderViewForDate.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomBorderViewForTime.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderViewForTime.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        bottomBorderViewForTime.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        bottomBorderViewForTime.widthAnchor.constraint(equalTo: timeLabel.widthAnchor, multiplier: 0.9).isActive = true
        bottomBorderViewForTime.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    //CalendarView
    func setupCalendarView() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissCalendarView)))
            window.addSubview(blackView)
            window.addSubview(calendarView)

            //calendar setup
            CalendarView.Style.cellShape                = .square
            CalendarView.Style.cellColorDefault         = UIColor.white
            CalendarView.Style.headerTextColor          = UIColor.black
            CalendarView.Style.cellTextColorDefault     = UIColor.black
            CalendarView.Style.cellTextColorToday       = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
            CalendarView.Style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
            
            CalendarView.Style.cellSelectedBorderColor  = Colors.maroon
            CalendarView.Style.cellSelectedColor        = Colors.maroon
            CalendarView.Style.cellSelectedTextColor    = UIColor.white

            //calendarView setup
            calendarView.setDisplayDate(Date())
            calendarView.backgroundColor = UIColor.white
            calendarView.multipleSelectionEnable = false
            calendarView.marksWeekends = false
            
           //CalendarView Constraints
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.7).isActive = true
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4).isActive = true
            
            //button Setup
            setupForwardBackwardButtons()
            
            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.calendarView.alpha = 1
            }
        }
    }
    
    func setupForwardBackwardButtons(){
        calendarView.addSubview(leftButton)
        calendarView.addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(handleCalendarLeft), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:10).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant:10).isActive = true
        
        rightButton.addTarget(self, action: #selector(handleCalendarRight), for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:10).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant:-10).isActive = true
    }
    
    @objc func handleDismissCalendarView(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.calendarView.alpha = 0
        }
    }
}

extension CreateRideViewController : CalendarViewDataSource, CalendarViewDelegate{
    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 0
        let today = Date()
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 3
        let today = Date()
        let threeMonthsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return threeMonthsFromNow
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {
        
    }
    
    
}
