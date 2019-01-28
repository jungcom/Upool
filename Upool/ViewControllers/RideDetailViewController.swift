//
//  RideDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class RideDetailViewController: UIViewController {

    var topContainer = UIView()
    
    // First Top View
    let firstTopView = UIView()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Jan 7th, 3 pm"
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    let departureCityLabel : UILabel = {
        let label = UILabel()
        label.text = "Amherst, MA"
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    let rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        return imageView
    }()
    
    let destinationCityLabel : UILabel = {
        let label = UILabel()
        label.text = "Boston, MA"
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    var locationStackView : UIStackView!
    
    let passengerSeatsLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers  1/2"
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    //Second Top View
    let secondTopView = UIView()
    
    let profileImageView : UIImageView = {
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
    
    let priceLabel : UILabel = {
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
    
    let pickupDetailTextView : UITextView = {
        let label = UITextView()
        label.text = "I can pick up anywhere between the campus and the main city hall. For other places, please contact me."
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        label.allowsEditingTextAttributes = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @objc func handleMessage(){
        
    }
    
    @objc func handleJoinRide(){
        
    }
}
