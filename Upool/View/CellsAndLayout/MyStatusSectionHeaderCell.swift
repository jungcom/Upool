//
//  MyStatusSectionHeaderCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class MyStatusSectionHeaderCell : UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){

    }
    
    func setupConstraints(){
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:20).isActive = true
//        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
