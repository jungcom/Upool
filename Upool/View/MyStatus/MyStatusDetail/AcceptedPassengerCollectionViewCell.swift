//
//  AcceptedPassengerCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/18/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class AcceptedPassengerCollectionViewCell: UICollectionViewCell {
    
    let db = Firestore.firestore()
    var rideRequest : RideRequest? {
        didSet{
            //Add joined Label
            addJoinedLabel()
            
            //Retrieve the requesting user data and show the name and profile image of that user
            if let request = rideRequest, let requestingUserId = request.fromId{
                db.collection("users").document(requestingUserId).getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else {return}
                    if let data = snapshot.data(), let requestingUser = UPoolUser(dictionary: data){
                        self.nameLabel.text = "\(requestingUser.firstName!)"
                        guard let profileImageUrl = requestingUser.profileImageUrl else {return}
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
            }
        }
    }
    
    func addJoinedLabel(){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "CheckMark")
        let attachmentImage = NSAttributedString(attachment: attachment)
        let attributes = [NSAttributedString.Key.foregroundColor : Colors.maroon,
                          NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 12)]
        let attachmentString = NSAttributedString(string: "Joined ", attributes: attributes as [NSAttributedString.Key : Any])
        let myString = NSMutableAttributedString(attributedString: attachmentString)
        myString.append(attachmentImage)
        joinedLabel.attributedText = myString
    }
    
    let nameLabel :UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let profileImageView :UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = UIColor.gray
        image.image = UIImage(named: "SmallPlusSign")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.gray.cgColor
        return image
    }()
    
    let joinedLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
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
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        joinedLabel.translatesAutoresizingMaskIntoConstraints = false
        joinedLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        joinedLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        joinedLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        joinedLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
