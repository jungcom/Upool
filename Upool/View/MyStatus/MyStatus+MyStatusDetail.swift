//
//  MyStatus.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension MyStatusViewController{
    func setupNavBar() {
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.alwaysBounceVertical = true
        
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
}

extension MyStatusDetailViewController{
    func setupNavBar() {
        
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    func setupTopPassengerDetailView(){
        //add subviews
        view.addSubview(topPassengerDetailView)
        topPassengerDetailView.addSubview(passengerStatusLabel)
        
        //The whole top ui view
        topPassengerDetailView.backgroundColor = UIColor.gray
        topPassengerDetailView.translatesAutoresizingMaskIntoConstraints = false
        topPassengerDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        topPassengerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        topPassengerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        topPassengerDetailView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        //Passenger Detail View
        passengerStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerStatusLabel.topAnchor.constraint(equalTo: topPassengerDetailView.topAnchor, constant: 20).isActive = true
        passengerStatusLabel.centerXAnchor.constraint(equalTo: topPassengerDetailView.centerXAnchor).isActive = true
        //passengerStatusLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
    }
    
    func setupAcceptedPassengerCollectionView(){
        topPassengerDetailView.addSubview(acceptedPassengersCollectionView)
        
        acceptedPassengersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        acceptedPassengersCollectionView.bottomAnchor.constraint(equalTo: topPassengerDetailView.bottomAnchor, constant: -12).isActive = true
        acceptedPassengersCollectionView.leadingAnchor.constraint(equalTo: topPassengerDetailView.leadingAnchor, constant: 12).isActive = true
        acceptedPassengersCollectionView.trailingAnchor.constraint(equalTo: topPassengerDetailView.trailingAnchor, constant: -12).isActive = true
        acceptedPassengersCollectionView.heightAnchor.constraint(equalTo: topPassengerDetailView.heightAnchor, multiplier: 0.5).isActive = true
    }
}
