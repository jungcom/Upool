//
//  JoinedRidesDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/10/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class JoinedRidesDetailViewController: UIViewController{
    
    let db = Firestore.firestore()
    
    var ridePost : RidePost!
    
    let joinedRidesDetailView : JoinedRidesDetailView = {
        let view = JoinedRidesDetailView()
        return view
    }()
    
    override func loadView() {
        joinedRidesDetailView.dateLabel.text = ridePost.dateString() + " at " + ridePost.timeString()
        joinedRidesDetailView.departureCityLabel.text = ridePost.departureCity!
        joinedRidesDetailView.destinationCityLabel.text = ridePost.arrivalCity!
        joinedRidesDetailView.priceLabel.text = "$\(ridePost.price!)"
        joinedRidesDetailView.pickupDetailTextView.text = (ridePost.pickUpDetails == "") ? "None" : ridePost.pickUpDetails
        setDriverProfileImageAndName()
        view = joinedRidesDetailView
    }
    
    func setDriverProfileImageAndName(){
        guard let driverId = ridePost.driverUid else { return }
        db.collection("users").document(driverId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            if let data = snapshot.data(), let driver = UPoolUser(dictionary: data){
                self.joinedRidesDetailView.driverNameLabel.text = "\(driver.firstName!)"
                guard let profileImageUrl = driver.profileImageUrl else {return}
                self.joinedRidesDetailView.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ride Details"
    }
}
