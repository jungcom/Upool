//
//  MyStatusDetail.swift
//  Upool
//
//  Created by Anthony Lee on 2/19/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit

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
        topPassengerDetailView.translatesAutoresizingMaskIntoConstraints = false
        topPassengerDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        topPassengerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        topPassengerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        topPassengerDetailView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        //Passenger Detail View
        passengerStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerStatusLabel.topAnchor.constraint(equalTo: topPassengerDetailView.topAnchor, constant: 20).isActive = true
        passengerStatusLabel.centerXAnchor.constraint(equalTo: topPassengerDetailView.centerXAnchor).isActive = true
        
    }
    
    func setupAcceptedPassengerCollectionView(){
        topPassengerDetailView.addSubview(acceptedPassengersCollectionView)
        
        acceptedPassengersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        acceptedPassengersCollectionView.bottomAnchor.constraint(equalTo: topPassengerDetailView.bottomAnchor, constant: -20).isActive = true
        acceptedPassengersCollectionView.leadingAnchor.constraint(equalTo: topPassengerDetailView.leadingAnchor, constant: 12).isActive = true
        acceptedPassengersCollectionView.trailingAnchor.constraint(equalTo: topPassengerDetailView.trailingAnchor, constant: -12).isActive = true
        acceptedPassengersCollectionView.heightAnchor.constraint(equalTo: topPassengerDetailView.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    func setupPendingPassengerCollectionView(){
        view.addSubview(pendingPassengersCollectionView)
        
        pendingPassengersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pendingPassengersCollectionView.topAnchor.constraint(equalTo: topPassengerDetailView.bottomAnchor).isActive = true
        pendingPassengersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pendingPassengersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pendingPassengersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
