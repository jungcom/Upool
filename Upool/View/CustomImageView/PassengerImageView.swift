//
//  PassengerImageView.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class PassengerImageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //we use lazy properties for each view
    lazy var passengerLabel : UILabel = {
        let label = UILabel()
        label.text = "Anthony"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    lazy var contentView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "MockProfileImage")
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(passengerLabel)
    }
    
    func setupConstraints(){
        passengerLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerLabel.topAnchor.constraint(equalTo: topAnchor, constant:10).isActive = true
        passengerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        passengerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }

}
