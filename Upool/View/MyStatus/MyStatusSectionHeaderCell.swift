//
//  MyStatusSectionHeaderCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class MyStatusSectionHeaderCell : UICollectionViewCell {
    
    var segmentTapped : ((Int) -> ())?
    var deleteButtonTapped : (() -> ())?
    
    lazy var segmentControl : UISegmentedControl = {
        let titles = ["My Rides","Joined Rides"]
        let segment = UISegmentedControl(items: titles)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.white
        segment.tintColor = Colors.maroon
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 16)!]
        segment.setTitleTextAttributes(stringAtt, for: .normal)
        segment.addTarget(self, action: #selector(segmentTappedFunc), for: .valueChanged)
        return segment
    }()
    
    lazy var deleteRideButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Trash"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTappedFunc), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupSegmentControl()
        setupTrashButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    func setupSegmentControl(){
        addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        segmentControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
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
    
    @objc func segmentTappedFunc(){
        segmentTapped?(segmentControl.selectedSegmentIndex)
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
