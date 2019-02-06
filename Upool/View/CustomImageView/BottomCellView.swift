//
//  BottomCellView.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class BottomCellView: UIView {
    
    var rideRequests : [RideRequest]?
    
    lazy var passengerLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var passengerStackView : UIStackView!
    
    lazy var passengerOne : PassengerImageView = {
        let view = PassengerImageView()
        return view
    }()
    
    lazy var passengerTwo : PassengerImageView = {
        let view = PassengerImageView()
        return view
    }()
    
    lazy var passengerThree : PassengerImageView = {
        let view = PassengerImageView()
        return view
    }()
    
    lazy var passengerFour : PassengerImageView = {
        let view = PassengerImageView()
        return view
    }()
    
    var passengerViewArray : [PassengerImageView] {
        return [passengerOne,passengerTwo,passengerThree,passengerFour]
    }
    
    //we use lazy properties for each view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("BottomViewSetup")
        setupView()
        setupPassengerStackView()
        setupConstraints()
        addDividingBorder()
    }
    
    init(requests:[RideRequest]){
        self.init()
        print("BottomViewSetup with request")
        self.rideRequests = requests
        setRequestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupPassengerStackView()
        setupConstraints()
        addDividingBorder()
    }
    
    func setRequestData(){
        if let rideRequests = rideRequests{
            var index = 0
            for request in rideRequests{
                passengerViewArray[index].rideRequest = request
                index += 1
            }
        }

    }
    
    private func setupView() {
        addSubview(passengerLabel)
    }
    
    func setupPassengerStackView(){
        passengerStackView = UIStackView(arrangedSubviews: [passengerOne,passengerTwo,passengerThree,passengerFour])
        passengerStackView.axis = .horizontal
        passengerStackView.alignment = .center
        passengerStackView.distribution = .fillEqually
        passengerStackView.spacing = 15
        
        addSubview(passengerStackView)
    }
    
    func setupConstraints(){
        
        //PassengerLabel Constraints
        passengerLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerLabel.topAnchor.constraint(equalTo: topAnchor, constant:10).isActive = true
        passengerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        passengerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        
        //PassengerLabel Constraints
        passengerStackView.translatesAutoresizingMaskIntoConstraints = false
        passengerStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant : 8).isActive = true
        passengerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        passengerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        passengerStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
                
    }
    
    func addDividingBorder(){
        let line = UIView()
        addSubview(line)
        line.addGrayBottomBorderTo(view: self, multiplier: 0.8, bottom: false, centered: true, color: UIColor.lightGray)
    }
    
}
