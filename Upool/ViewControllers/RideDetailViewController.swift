//
//  RideDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class RideDetailViewController: UIViewController {

    let db = Firestore.firestore()
    var ridePost : RidePost!
    var driver : UPoolUser?
    
    let scrollView = UIScrollView()
    
    var topContainer = UIView()
    
    // First Top View
    let firstTopView = UIView()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.dateString() + " " + ridePost.timeString()
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    lazy var departureCityLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.departureCity!
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    let rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        imageView.tintColor = Colors.maroon
        return imageView
    }()
    
    lazy var destinationCityLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.arrivalCity!
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    var locationStackView : UIStackView!
    
    lazy var passengerSeatsLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers  \(ridePost.currentPassengers!)/\(ridePost.maxPassengers!)"
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    //Second Top View
    let secondTopView = UIView()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.backgroundColor = UIColor.blue
        imageView.tintColor = UIColor.blue
        imageView.image = UIImage(named: "MockProfileImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Robinson Crusoe"
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    let driverInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "\u{2022}Major in Computer Science"
        label.font = UIFont(name: Fonts.futura, size: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$20"
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.moneyGreen
        return label
    }()
    
    //Third Top View
    let thirdTopView = UIView()
    
    let pickUpLabel : UILabel = {
        let label = UILabel()
        label.text = "Pickup Details"
        label.font = UIFont(name: Fonts.futura, size: 17)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var pickupDetailTextView : UITextView = {
        let label = UITextView()
        label.text = "I can pick up anywhere between the campus and the main city hall. For other places, please contact me."
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        label.isEditable = false
        label.isScrollEnabled = false
        return label
    }()
    
    //Fourth Top view
    let buttonView = UIView()
    
    var buttonStackView : UIStackView!
    
    let messageButton : UIButton = {
        let button = UIButton()
        button.setTitle("MESSAGE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        return button
    }()
    
    let joinRideButton : UIButton = {
        let button = UIButton()
        button.setTitle("JOIN RIDE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 17)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleJoinRide), for: .touchUpInside)
        return button
    }()
    
    //Bottom Container
    
    let bottomContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        retrieveDriver()
    }
    
    @objc func handleMessage(){
        
    }
    
    @objc func handleJoinRide(){
        let alert = UIAlertController(title: "Join Ride?", message: "Are you sure you want to join this ride?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.joinRideButton.requestedOrJoined(joined: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func retrieveDriver(){
        db.collection("users").document(ridePost.driverUid!).getDocument { (snapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            } else {
                if let dictionary = snapShot?.data(){
                    self.driver = UPoolUser(dictionary: dictionary)
                    self.nameLabel.text = "\(self.driver?.firstName ?? "") \(self.driver?.lastName ?? "")"
                    //TODO : Set User Profile Image
                } else {
                    print("driver not found")
                }
            }
        }
    }
    
    func sendRequestToDriver(){
        
    }
}
