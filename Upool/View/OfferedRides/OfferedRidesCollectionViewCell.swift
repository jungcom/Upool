//
//  OfferedRidesCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 1/24/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class OfferedRidesCollectionViewCell: UICollectionViewCell {
    
    let db = Firestore.firestore()
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, "
        return formatter
    }()
    
    let timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var post : RidePost!{
        didSet{
            if let arrCity = post.arrivalCity {
                destinationCityLabel.text = arrCity
            }
            if let departureCity = post.departureCity {
                departureCityLabel.text = departureCity
            }
            if let time = post.departureTime, let date = post.departureDate {
                dateLabel.text = dateFormatter.string(from: date) + timeFormatter.string(from: time)
            }
            if let price = post.price {
                priceLabel.text = "$\(price)"
            }
            if let maxPassenger = post.maxPassengers, let currentPassengers = post.currentPassengers {
                passengerSeatsLabel.text = "Passengers \(currentPassengers)/\(maxPassenger)"
            }
            if let driverId = post.driverUid{
                setupImageProfileView(driverId)
            }
        }
    }
    
    func setupImageProfileView(_ driverId : String){
        db.collection("users").document(driverId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, let data = snapshot.data() else {return}
            let user = UPoolUser(dictionary: data)
            if let url = user?.profileImageUrl {
                self.profileImageView.loadImageUsingCacheWithUrlString(url)
            }
        }
    }
    
    //Top UI View
    
    let topUIView : UIView = {
        let view = UIView()
        return view
    }()
    
    var topViewHeightConstraintWhenNotTapped : NSLayoutConstraint!
    var topViewHeightConstraintWhenTapped : NSLayoutConstraint!
    
    var locationStackView : UIStackView!
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.backgroundColor = UIColor.gray
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(named: "ProfileImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Jan 7th, 3 pm"
        label.font = UIFont(name: Fonts.futuraMedium, size: 16)
        return label
    }()
    
    let departureCityLabel : UILabel = {
        let label = UILabel()
        label.text = "Amherst, MA"
        label.font = UIFont(name: Fonts.futura, size: 15)
        label.textColor = Colors.maroon
        label.textAlignment = .center
        return label
    }()
    
    let rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        imageView.tintColor = Colors.maroon
        return imageView
    }()
    
    let destinationCityLabel : UILabel = {
        let label = UILabel()
        label.text = "Boston, MA"
        label.font = UIFont(name: Fonts.futura, size: 15)
        label.textColor = Colors.maroon
        label.textAlignment = .center
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
        setupTopViews()
        setupLocationStackView()
        setupTopConstraints()
        UIView.dropShadow(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTopViews(){
        backgroundColor? = UIColor.white
        
        topUIView.addSubview(profileImageView)
        topUIView.addSubview(dateLabel)
        topUIView.addSubview(priceLabel)
        topUIView.addSubview(passengerSeatsLabel)
        
        addSubview(topUIView)
    }
    
    func setupLocationStackView(){
        locationStackView = UIStackView(arrangedSubviews: [departureCityLabel, rightArrowIconImageView, destinationCityLabel])
        locationStackView.axis = .horizontal
        locationStackView.distribution = .equalCentering
        locationStackView.alignment = .center
        addSubview(locationStackView)
    }
    
    func setupTopConstraints(){
        
        //TopViewConstraints
        topUIView.translatesAutoresizingMaskIntoConstraints = false
        topUIView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topUIView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        //save the constraint to change later
        topViewHeightConstraintWhenNotTapped = topUIView.heightAnchor.constraint(equalTo: heightAnchor)
        topViewHeightConstraintWhenTapped = topUIView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: (1.0/3.0))
        topViewHeightConstraintWhenNotTapped.isActive = true
        topUIView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //ProfileImageView constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topUIView.topAnchor, constant: 12).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: topUIView.leadingAnchor, constant: 12).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: topUIView.bottomAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: topUIView.heightAnchor, multiplier: 0.75).isActive = true
        
        //DateLabel Constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: topUIView.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: topUIView.heightAnchor, multiplier: 0.25).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: topUIView.widthAnchor, multiplier: 0.5).isActive = true
    
        //LocationStackView Constraints
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        locationStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        locationStackView.trailingAnchor.constraint(equalTo: topUIView.trailingAnchor, constant: -18).isActive = true
        locationStackView.heightAnchor.constraint(equalTo: topUIView.heightAnchor, multiplier: 0.2).isActive = true
        
        //PriceLabel Constraints
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.trailingAnchor.constraint(equalTo: topUIView.trailingAnchor, constant : -8).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: topUIView.bottomAnchor, constant: -8).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: locationStackView.heightAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Passenger Seats Label Constraints
        passengerSeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerSeatsLabel.topAnchor.constraint(equalTo: topUIView.topAnchor, constant: 3).isActive = true
        passengerSeatsLabel.trailingAnchor.constraint(equalTo: topUIView.trailingAnchor, constant: -3).isActive = true
        passengerSeatsLabel.heightAnchor.constraint(equalTo: topUIView.heightAnchor, multiplier: 0.15).isActive = true
        passengerSeatsLabel.widthAnchor.constraint(equalTo: topUIView.widthAnchor, multiplier: 0.3).isActive = true
    }
}
