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
import Firebase

class CreateRideViewController: UIViewController {

    //Current User
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    let db = Firestore.firestore()
    //This will be set as a Data Model
    var ridePost : RidePost {
        let post = RidePost()
        post.departureDate = departureDate
        post.departureTime = departureTime
        post.departureCity = departureCity
        post.arrivalCity = arrivalCity
        post.price = price
        post.maxPassengers = maxPassengers
        post.pickUpDetails = pickUpDetails
        return post
    }
    
    var departureDate : Date?
    var departureTime : Date?
    var departureCity : String?
    var arrivalCity : String?
    var price : Int {
        return Int(priceSlider.value)
    }
    var maxPassengers : Int{
        return Int(passengerCosmosView.rating)
    }
    var pickUpDetails : String{
        return pickupDetailsTextView.text
    }

    //Date Formatters
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    let timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    //UIVIews
    
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
        cosmos.rating = 2
        cosmos.settings.totalStars = 4
        cosmos.settings.filledColor = Colors.maroon
        cosmos.settings.filledBorderColor = Colors.maroon
        cosmos.settings.emptyColor = UIColor.white
        cosmos.settings.emptyBorderColor = Colors.maroon
        cosmos.settings.starSize = 25
        
        //TODO: Setup image to be round
        cosmos.settings.emptyImage = UIImage(named: "UnfilledPassengers1")
        cosmos.settings.filledImage = UIImage(named: "FilledPassengers1")
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
        textView.text = "Payment in Cash"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.textColor = UIColor.black
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
    
    lazy var okButtonForCalendar : UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleOKForCalendar), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButtonForCalendar : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleDismissCalendarView), for: .touchUpInside)
        return button
    }()
    
    //DatePickerView
    let timePickerPopupView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    lazy var okButtonForTimePicker : UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleOKForTimePicker), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButtonForTimePicker : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleDismissTimePicker), for: .touchUpInside)
        return button
    }()
    
    
    //MARK : ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleCalendarView(){
        setupCalenderAndBottomButtonViews()
    }
    
    @objc func handleTimePickerView(){
        setupTimePickerWholeView()
    }
    
    @objc func handleFromView(){
        let searchLocationVC = SearchLocationViewController()
        searchLocationVC.delegate = self
        searchLocationVC.forDeparture = true
        let nav = UINavigationController(rootViewController: searchLocationVC)
        self.present(nav, animated: true, completion: nil)
    }

    @objc func handleToView(){
        let searchLocationVC = SearchLocationViewController()
        searchLocationVC.delegate = self
        searchLocationVC.forDeparture = false
        let nav = UINavigationController(rootViewController: searchLocationVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func sliderValueChanged(){
        let roundedValue = round(priceSlider.value / 5) * 5
        priceSlider.value = roundedValue
        dollarLabel.text = "$\(Int(priceSlider.value))"
    }
    
    @objc func handleCreateRide(){
        guard let user = authUser else {
            print("No Current User Found")
            return
        }
        
        guard ridePost.allFieldsFull else {
            let alert = UIAlertController(title: "All fields must be filled", message: nil, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        //Create a new ridePost and add it to the server database
        let ref = db.collection("ridePosts").document()
        let newRidePost = ridePost.copy() as! RidePost
        newRidePost.ridePostUid = ref.documentID
        newRidePost.driverUid = user.uid
        ref.setData(newRidePost.dictionary) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
