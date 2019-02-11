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
            db.collection("users").document(chatPartnerId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching document in Chat User Cell: \(error!)")
                    return
                }
                if let toUser = UPoolUser(dictionary: snapshot.data()!){
                    self.textLabel?.text = toUser.firstName
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
            detailTextLabel?.text = message?.text
            
            //set timestamp
            if let time = message?.timeStamp{
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "h:mm a"
                timeLabel.text = dateformatter.string(from: time)
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width - 100, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = UIColor.gray
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        //timeLabel contraints
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
