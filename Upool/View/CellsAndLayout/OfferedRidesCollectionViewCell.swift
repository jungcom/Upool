//
//  OfferedRidesCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 1/24/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class OfferedRidesCollectionViewCell: UICollectionViewCell {
    
    var locationStackView : UIStackView!
    
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
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Jan 7th, 3 pm"
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    let departureCityLabel : UILabel = {
        let label = UILabel()
        label.text = "Amherst, MA"
        label.font = UIFont(name: Fonts.futura, size: 15)
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
        label.font = UIFont(name: Fonts.futura, size: 15)
        label.textColor = Colors.maroon
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$20"
        label.textColor = Colors.moneyGreen
        label.textAlignment = .right
        return label
    }()
    
    let passengerSeatsLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers  1/2"
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupStackView()
        setupConstraints()
        dropShadow()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.cornerRadius = 5.0
    }
    
    func setupViews(){
        backgroundColor? = UIColor.white
        
        addSubview(profileImageView)
        addSubview(dateLabel)
        addSubview(priceLabel)
        addSubview(passengerSeatsLabel)
    }
    
    func setupStackView(){
        locationStackView = UIStackView(arrangedSubviews: [departureCityLabel, rightArrowIconImageView, destinationCityLabel])
        locationStackView.axis = .horizontal
        locationStackView.distribution = .equalCentering
        locationStackView.alignment = .center
        addSubview(locationStackView)
    }
    
    func setupConstraints(){
        
        //ProfileImageView constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        
        //DateLabel Constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    
        //LocationStackView Constraints
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        locationStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        locationStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        locationStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        //PriceLabel Constraints
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -8).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: locationStackView.heightAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Passenger Seats Label Constraints
        passengerSeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerSeatsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        passengerSeatsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        passengerSeatsLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        passengerSeatsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
    }
}
