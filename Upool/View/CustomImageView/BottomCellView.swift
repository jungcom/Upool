//
//  BottomCellView.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class BottomCellView: UIView {
    
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
    
    //we use lazy properties for each view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupPassengerStackView()
        setupConstraints()
        addDividingBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(passengerLabel)
    }
    
    func setupPassengerStackView(){
        passengerStackView = UIStackView(arrangedSubviews: [passengerOne,passengerTwo,passengerThree,passengerFour])
        passengerStackView.axis = .horizontal
        passengerStackView.alignment = .center
        passengerStackView.distribution = .fillEqually
        passengerStackView.spacing = 25
        
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
        passengerStackView.topAnchor.constraint(equalTo: passengerLabel.bottomAnchor, constant:10).isActive = true
        passengerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        passengerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        passengerStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
                
    }
    
    func addDividingBorder(){
        let line = UIView()
        addSubview(line)
        line.addGrayBottomBorderTo(view: self, multiplier: 0.8, bottom: false, centered: true, color: UIColor.lightGray)
    }
    
}
