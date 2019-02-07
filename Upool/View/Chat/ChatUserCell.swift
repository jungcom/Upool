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
    
    fileprivate func setupName() {
        let chatPartnerId: String?
        
        if message?.fromId == Auth.auth().currentUser?.uid{
            chatPartnerId = message?.toId
        } else{
            chatPartnerId = message?.fromId
        }
        
        //Get User Info
//        if let chatPartnerId = message?.chatPartnerId() {
//            let ref = Database.database().reference(fromURL: Constants.databaseURL).child("users").child(chatPartnerId)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String:AnyObject]{
//                    self.textLabel?.text = dictionary["firstName"] as? String
//                }
//            }, withCancel: nil)
//
//        }
    }
    
    var message: Message?{
        didSet{
            setupName()
            
            //set text
            detailTextLabel?.text = message?.text
            
            //set timestamp
//            if let seconds = message?.timeStamp?.doubleValue{
//                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
//                let dateformatter = DateFormatter()
//                dateformatter.dateFormat = "hh:mm a"
//                timeLabel.text = dateformatter.string(from: timeStampDate as Date)
//            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
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
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
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
