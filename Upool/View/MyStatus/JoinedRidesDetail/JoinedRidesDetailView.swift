//
//  JoinedRidesDetail.swift
//  Upool
//
//  Created by Anthony Lee on 3/10/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class JoinedRidesDetailView : UIView {
    
    //RideLocation View (Top View Container)
    let rideLocationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    lazy var departureCityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.helvetica, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    lazy var rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        imageView.tintColor = Colors.maroon
        return imageView
    }()
    
    lazy var destinationCityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.helvetica, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.moneyGreen
        label.textAlignment = .right
        return label
    }()
    
    var locationStackView : UIStackView!
    
    //Driver Detail View
    
    lazy var driverDetailView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var driverDetailLabel : UILabel = {
        let label = UILabel()
        label.text = "Driver Details"
        label.font = UIFont(name: Fonts.helvetica, size: 20)
        label.textColor = Colors.maroon
        label.textAlignment = .center
        return label
    }()
    
    lazy var driverNameLabel :UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var profileImageView :UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = UIColor.gray
        image.image = UIImage(named: "SmallPlusSign")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.gray.cgColor
        return image
    }()
    
    lazy var pickUpLabel : UILabel = {
        let label = UILabel()
        label.text = "Pickup Details:"
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var pickupDetailTextView : UITextView = {
        let label = UITextView()
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        label.textColor = UIColor.gray
        label.isEditable = false
        label.isScrollEnabled = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        setupTopContainer()
        setupDriverDetailView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTopContainer(){
        addSubview(rideLocationView)
        UIView.dropShadow(view: rideLocationView)
        
        locationStackView = UIStackView(arrangedSubviews: [departureCityLabel, rightArrowIconImageView, destinationCityLabel])
        locationStackView.axis = .horizontal
        locationStackView.distribution = .equalCentering
        locationStackView.alignment = .center
        
        rideLocationView.addSubview(dateLabel)
        rideLocationView.addSubview(locationStackView)
        rideLocationView.addSubview(priceLabel)
        
        //MARK : First Top View Constraints
        rideLocationView.translatesAutoresizingMaskIntoConstraints = false
        rideLocationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        rideLocationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rideLocationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rideLocationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        
        //dateLabel Constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: rideLocationView.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: rideLocationView.leadingAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: rideLocationView.widthAnchor, multiplier: 0.7).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: rideLocationView.heightAnchor, multiplier: 0.2).isActive = true
        
        //location View Constraints
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.centerXAnchor.constraint(equalTo: rideLocationView.centerXAnchor).isActive = true
        locationStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant:0).isActive = true
        locationStackView.widthAnchor.constraint(equalTo: rideLocationView.widthAnchor, multiplier: 0.8).isActive = true
        locationStackView.heightAnchor.constraint(equalTo: rideLocationView.heightAnchor, multiplier: 0.6).isActive = true
        
        //PriceLabel View Constraints
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.bottomAnchor.constraint(equalTo: rideLocationView.bottomAnchor, constant: -10).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: rideLocationView.trailingAnchor, constant: -10).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: rideLocationView.widthAnchor, multiplier: 0.4).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: rideLocationView.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupDriverDetailView(){
        addSubview(driverDetailView)
        UIView.dropShadow(view: driverDetailView)
        driverDetailView.addSubview(driverDetailLabel)
        driverDetailView.addSubview(driverNameLabel)
        driverDetailView.addSubview(profileImageView)
        driverDetailView.addSubview(pickUpLabel)
        driverDetailView.addSubview(pickupDetailTextView)
        
        driverDetailView.translatesAutoresizingMaskIntoConstraints = false
        driverDetailView.topAnchor.constraint(equalTo: rideLocationView.bottomAnchor, constant: 30).isActive = true
        driverDetailView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        driverDetailView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        driverDetailView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        //DriverDetail Label Constraints
        driverDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        driverDetailLabel.topAnchor.constraint(equalTo: driverDetailView.topAnchor, constant:8).isActive = true
        driverDetailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        driverDetailLabel.heightAnchor.constraint(equalTo: driverDetailView.heightAnchor, multiplier: 0.2).isActive = true
        
        //Pickup Label Constraints
        driverNameLabel.translatesAutoresizingMaskIntoConstraints = false
        driverNameLabel.topAnchor.constraint(equalTo: driverDetailLabel.bottomAnchor, constant:8).isActive = true
        driverNameLabel.leadingAnchor.constraint(equalTo: driverDetailView.leadingAnchor, constant:15).isActive = true
        driverNameLabel.widthAnchor.constraint(equalTo: driverDetailView.widthAnchor, multiplier: 0.2).isActive = true
        
        //profileImageView Constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: driverNameLabel.bottomAnchor, constant: 5).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: driverNameLabel.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: driverNameLabel.widthAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: driverNameLabel.widthAnchor).isActive = true
        
        //Pickup Detail View Constraints
        pickUpLabel.translatesAutoresizingMaskIntoConstraints = false
        pickUpLabel.topAnchor.constraint(equalTo: driverNameLabel.topAnchor).isActive = true
        pickUpLabel.leadingAnchor.constraint(equalTo: driverDetailLabel.leadingAnchor).isActive = true
        
        //Pickup Detail TextView Constraints
        pickupDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        pickupDetailTextView.topAnchor.constraint(equalTo: pickUpLabel.bottomAnchor).isActive = true
        pickupDetailTextView.leadingAnchor.constraint(equalTo: driverDetailLabel.leadingAnchor).isActive = true
        pickupDetailTextView.trailingAnchor.constraint(equalTo: driverDetailView.trailingAnchor).isActive = true
        pickupDetailTextView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
    }
}
