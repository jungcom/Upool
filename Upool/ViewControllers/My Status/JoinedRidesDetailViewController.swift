//
//  JoinedRidesDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/10/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class JoinedRidesDetailViewController: UIViewController{
    
    var ridePost : RidePost? {
        didSet{
            
        }
    }
    
    let joinedRidesDetailView : JoinedRidesDetailView = {
        let view = JoinedRidesDetailView()
        return view
    }()
    
    override func loadView() {
        view = joinedRidesDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
