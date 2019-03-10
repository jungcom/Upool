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
        label.font = UIFont(name: Fonts.futura, size: 18)
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
        label.font = UIFont(name: Fonts.futura, size: 18)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        setupTopContainer()
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
}
