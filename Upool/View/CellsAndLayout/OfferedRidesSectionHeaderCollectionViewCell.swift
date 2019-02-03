//
//  OfferedRidesSectionHeaderCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 1/25/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

struct headerType {
    static let today = "Today"
    static let tomorrow = "Tomorrow"
    static let laterRides = "Later Rides"
}

class OfferedRidesSectionHeaderCollectionViewCell: UICollectionViewCell {
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = headerType.today
        label.font = UIFont(name: Fonts.futura, size: 20)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(titleLabel)
    }
    
    func setupConstraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
