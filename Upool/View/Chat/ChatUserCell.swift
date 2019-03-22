//
//  ChatUserCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class ChatUserCell: UITableViewCell {
    
    let db = Firestore.firestore()
    
    fileprivate func setupNameAndProfileImage() {
        
        if let chatPartnerId = message?.chatPartnerId(){
            db.collection(FirebaseDatabaseKeys.usersKey).document(chatPartnerId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    return
                }
                if let toUser = UPoolUser(dictionary: snapshot.data()!){
                    self.nameLabel.text = toUser.firstName
                    if let profileImageUrl = toUser.profileImageUrl{
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
            }
        }
    }
    
    var message: Message?{
        didSet{
            setupNameAndProfileImage()
            
            //set text
            detailLabel.text = message?.text
            
            //set timestamp
            if let time = message?.timeStamp{
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "h:mm a"
                timeLabel.text = dateformatter.string(from: time)
            }
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ProfileImagePlaceholder")
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        //layoutSubviews()
        addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        //timeLabel contsraints
        addSubview(timeLabel)
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant : -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        //NameLabel Constraints
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant : 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier:0.5).isActive = true
        
        //detail Label
        addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
