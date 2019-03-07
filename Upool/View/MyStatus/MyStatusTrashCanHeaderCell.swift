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
        deleteRideButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteRideButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func deleteButtonTappedFunc(){
        let alert = UIAlertController(title: "Delete Ride Post", message: "Are you sure you want to delete this ride?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let declineAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.deleteButtonTapped?()
        }
        alert.addAction(cancelAction)
        alert.addAction(declineAction)
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
}
