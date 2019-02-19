//
//  PendingPassengerViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/19/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class PendingPassengerCollectionViewCell: UICollectionViewCell {
    lazy var nameLabel :UILabel = {
        let label = UILabel()
        label.text = "Bob Marley wants to join your ride"
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        label.textAlignment = .left
        return label
    }()

    lazy var profileImageView :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ProfileImagePlaceholder")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()

    lazy var declineButton : UIButton = {
        let button = UIButton()
        button.setTitle("DECLINE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
        return button
    }()
    
    lazy var acceptButton : UIButton = {
        let button = UIButton()
        button.setTitle("ACCEPT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.white
        setupConstraints()
        UIView.dropShadow(view: self)
    }
    
    func setupConstraints(){
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(declineButton)
        addSubview(acceptButton)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -8).isActive = true
        acceptButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        declineButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant:-8).isActive = true
        declineButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDecline(){
        print("Decline")
    }
    
    @objc func handleAccept(){
        print("Accept")
    }
}
