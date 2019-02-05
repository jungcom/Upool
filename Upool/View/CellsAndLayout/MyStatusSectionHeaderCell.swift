//
//  MyStatusSectionHeaderCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class MyStatusSectionHeaderCell : UICollectionViewCell {
    
    let segmentControl : UISegmentedControl = {
        let titles = ["My Rides","Joined Rides"]
        let segment = UISegmentedControl(items: titles)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.white
        segment.tintColor = Colors.maroon
        
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 16)!]
        segment.setTitleTextAttributes(stringAtt, for: .normal)
        return segment
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
        addSubview(segmentControl)
    }
    
    func setupConstraints(){
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        segmentControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}
