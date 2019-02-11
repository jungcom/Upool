//
//  CreateRideCalendarView.swift
//  Upool
//
//  Created by Anthony Lee on 1/29/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import KDCalendar

extension CreateRideViewController : CalendarViewDataSource, CalendarViewDelegate{
    //Whole View
    func setupCalenderAndBottomButtonViews(){
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissCalendarView)))
            window.addSubview(blackView)
            window.addSubview(calendarPopupView)
            
            //CalendarPopUpView Constraints
            calendarPopupView.translatesAutoresizingMaskIntoConstraints = false
            calendarPopupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calendarPopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            calendarPopupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.7).isActive = true
            calendarPopupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.4).isActive = true
            
            //add CalendarView inside CalendarPopupView
            setupCalendarView()
            setupOkAndCancelButtons()
            
            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.calendarPopupView.alpha = 1
            }
        }
    }
    
    func setupCalendarView() {
        calendarPopupView.addSubview(calendarView)
        
        //calendar style setup
        setupCalendarStyle()
        
        //CalendarView Constraints
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.topAnchor.constraint(equalTo: calendarPopupView.topAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: calendarPopupView.trailingAnchor).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: calendarPopupView.leadingAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalTo: calendarPopupView.heightAnchor, multiplier:0.9).isActive = true
        
        //button Setup withing calendarView
        setupForwardBackwardButtons()
        
    }
    
    fileprivate func setupCalendarStyle() {
        CalendarView.Style.cellShape                = .square
        CalendarView.Style.cellColorDefault         = UIColor.white
        CalendarView.Style.headerTextColor          = UIColor.black
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.black
        CalendarView.Style.cellColorToday           = UIColor.white
        
        CalendarView.Style.cellSelectedBorderColor  = Colors.maroon
        CalendarView.Style.cellSelectedColor        = Colors.maroon
        CalendarView.Style.cellSelectedTextColor    = UIColor.white
        
        //calendarView setup
        calendarView.setDisplayDate(Date())
        calendarView.backgroundColor = UIColor.white
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = false
    }
    
    func setupForwardBackwardButtons(){
        calendarView.addSubview(leftButton)
        calendarView.addSubview(rightButton)
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:10).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant:10).isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:10).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant:-10).isActive = true
    }
    
    func setupOkAndCancelButtons(){
        calendarPopupView.addSubview(okButtonForCalendar)
        calendarPopupView.addSubview(cancelButtonForCalendar)
        
        okButtonForCalendar.translatesAutoresizingMaskIntoConstraints = false
        okButtonForCalendar.bottomAnchor.constraint(equalTo: calendarPopupView.bottomAnchor, constant:-10).isActive = true
        okButtonForCalendar.trailingAnchor.constraint(equalTo: calendarPopupView.trailingAnchor, constant:-20).isActive = true
        
        cancelButtonForCalendar.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonForCalendar.bottomAnchor.constraint(equalTo: okButtonForCalendar.bottomAnchor).isActive = true
        cancelButtonForCalendar.trailingAnchor.constraint(equalTo: okButtonForCalendar.leadingAnchor, constant:-30).isActive = true
    }
    
    @objc func handleDismissCalendarView(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.calendarPopupView.alpha = 0
        }
    }
    
    @objc func handleCalendarRight(){
        calendarView.goToNextMonth()
    }
    
    @objc func handleCalendarLeft(){
        calendarView.goToPreviousMonth()
    }
    
    @objc func handleOKForCalendar(){
        if let date = departureDate{
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.textColor = Colors.maroon
        } else {
            dateLabel.text = "Date"
            dateLabel.textColor = UIColor.gray
        }
        handleDismissCalendarView()
    }
    
    //CalendarView Delegates
    
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
        
        departureDate = date.toGlobalTime()
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        if yesterday! > date{
            return false
        }
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        departureDate = nil
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {
        
    }
}
