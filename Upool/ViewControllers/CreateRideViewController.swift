//
//  CreateRideViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import KDCalendar
import Cosmos

class CreateRideViewController: UIViewController {

    let formatter = DateFormatter()
    
    var dateTimeStack : UIStackView!
    var fromToStack : UIStackView!
    var priceStack : UIStackView!
    var passengerStack : UIStackView!
    
    //Date and Time View
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
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTimePickerView)))
        return label
    }()
    
    //Destination View
    lazy var fromLabel : UILabel = {
        let label = UILabel()
        label.text = "From"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFromView)))
        return label
    }()
    
    lazy var toLabel : UILabel = {
        let label = UILabel()
        label.text = "To"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleToView)))
        return label
    }()
    
    //Price View
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var priceSlider : UISlider = {
        let slider = UISlider()
        slider.maximumValue = 50
        slider.minimumValue = 0
        slider.addTarget (self,
                          action: #selector(sliderValueChanged),
                          for: UIControl.Event.valueChanged
        )
        return slider
    }()
    
    lazy var dollarLabel : UILabel = {
        let label = UILabel()
        label.text = "$\(Int(priceSlider.value))"
        label.textColor = Colors.moneyGreen
        label.textAlignment = .right
        return label
    }()
    
    //Passengers View
    lazy var passengerLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var passengerCosmosView : CosmosView = {
        let cosmos = CosmosView()
        cosmos.settings.totalStars = 6
        cosmos.settings.filledColor = Colors.maroon
        cosmos.settings.filledBorderColor = Colors.maroon
        cosmos.settings.emptyColor = UIColor.white
        cosmos.settings.emptyBorderColor = Colors.maroon
        cosmos.settings.starSize = 25
        
        //TODO: Setup image to be round
//        cosmos.settings.emptyImage
//        cosmos.settings.filledImage
        return cosmos
    }()
    
    //PickDetails View
    lazy var pickupDetailsLabel : UILabel = {
        let label = UILabel()
        label.text = "Pickup Details"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var pickupDetailsTextView : UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.textColor = UIColor.gray
        textView.font = UIFont(name: Fonts.helvetica, size: 14)
        return textView
    }()
    
    //Create Button View
    let createRideButton : UIButton = {
        let button = UIButton()
        button.setTitle("CREATE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCreateRide), for: .touchUpInside)
        return button
    }()
    
    
    //CalendarView
    let calendarPopupView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let blackView : UIView = {
        let black = UIView()
        black.backgroundColor = UIColor(white: 0, alpha: 0.5)
        black.alpha = 0
        return black
    }()
    
    lazy var leftButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.leftArrow), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(handleCalendarLeft), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.rightArrow), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(handleCalendarRight), for: .touchUpInside)
        return button
    }()
    
    let calendarView : CalendarView = {
        let cv = CalendarView()
        return cv
    }()
    
    lazy var okButton : UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleOK), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleDismissCalendarView), for: .touchUpInside)
        return button
    }()
    
    
    //DatePickerView
    lazy var timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.dataSource = self
        calendarView.delegate = self
        setupUI()
    }
    
    @objc func handleCalendarView(){
        setupCalenderAndBottomButtonViews()
    }
    
    @objc func handleTimePickerView(){
        setupTimePicker()
    }
    
    @objc func handleFromView(){
        let searchLocationVC = SearchLocationViewController()
        self.present(searchLocationVC, animated: true, completion: nil)
    }

    @objc func handleToView(){
        let searchLocationVC = SearchLocationViewController()
        self.present(searchLocationVC, animated: true, completion: nil)
    }
    
    @objc func sliderValueChanged(){
        dollarLabel.text = "$\(Int(priceSlider.value))"
    }
    
    @objc func handleCreateRide(){
        
    }
    
}
