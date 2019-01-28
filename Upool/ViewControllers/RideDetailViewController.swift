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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Ride Details"
        
        setupFirstTopView()
        setupSecondTopView()
    }
}
