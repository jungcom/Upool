//
//  MyStatusTrashCanHeaderCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/17/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class MyStatusTrashCanHeaderCell : UICollectionViewCell {
    
    var deleteButtonTapped : (() -> ())?
    
    lazy var deleteRideButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Trash"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTappedFunc), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupTrashButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupTrashButton(){
        addSubview(deleteRideButton)
        
        //Trash button
        deleteRideButton.translatesAutoresizingMaskIntoConstraints = false
        deleteRideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: frame.width*(-0.05)).isActive = true
        deleteRideButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        deleteRideButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        deleteRideButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    @objc func deleteButtonTappedFunc(){
        deleteButtonTapped?()
    }
}
