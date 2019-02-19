//
//  AcceptedPassengerCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/18/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class AcceptedPassengerCollectionViewCell: UICollectionViewCell {
    let nameLabel :UILabel = {
        let label = UILabel()
        label.text = "Bob Marley"
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 11)
        return label
    }()
    
    let profileImageView :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ProfileImagePlaceholder")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    let joinedLabel : UILabel = {
        let label = UILabel()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "CheckMark")
        let attachmentImage = NSAttributedString(attachment: attachment)
        let attributes = [NSAttributedString.Key.foregroundColor : Colors.maroon,
                          NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 12)]
        let attachmentString = NSAttributedString(string: "Joined", attributes: attributes)
        let myString = NSMutableAttributedString(attributedString: attachmentString)
        myString.append(attachmentImage)
        
        label.attributedText = myString
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupConstraints()
    }
    
    func setupConstraints(){
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(joinedLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        joinedLabel.translatesAutoresizingMaskIntoConstraints = false
        joinedLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        joinedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        joinedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        joinedLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
