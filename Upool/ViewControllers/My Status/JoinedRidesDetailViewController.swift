//
//  JoinedRidesDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/10/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class JoinedRidesDetailViewController: UIViewController{
    
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
//        joinedRidesDetailView.pickupDetailTextView.text = (ridePost.pickUpDetails == "") ? "None" : ridePost.pickUpDetails
        view = joinedRidesDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
