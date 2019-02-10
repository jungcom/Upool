//
//  ChatMessageCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/8/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UICollectionViewCell{
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleTrailingAnchor: NSLayoutConstraint?
    var bubbleLeadingAnchor: NSLayoutConstraint?
    
    var message : Message? {
        didSet{
            textView.text = message?.text
            //if message is my message
            if message!.fromId == Auth.auth().currentUser?.uid{
                bubbleView.backgroundColor = Colors.maroon
                textView.textColor = UIColor.white
                bubbleLeadingAnchor?.isActive = false
                bubbleTrailingAnchor?.isActive = true
                profileImageView.isHidden = true
            //else if message is other person's message
            } else {
                bubbleView.backgroundColor = UIColor.white
                textView.textColor = UIColor.black
                bubbleTrailingAnchor?.isActive = false
                bubbleLeadingAnchor?.isActive = true
                profileImageView.isHidden = false
            }
        }
    }
    
    var toUser : UPoolUser?{
        didSet{
            if let url = toUser?.profileImageUrl{
                profileImageView.loadImageUsingCacheWithUrlString(url)
            }
        }
    }
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.font = UIFont(name: Fonts.helvetica, size: 16)
        return textView
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.maroon
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileIcon")
        imageView.tintColor = UIColor.gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
    }
    
    func setupConstraints(){
        //Bubble Constraints
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        //If the message is the user's
        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-8)
        bubbleTrailingAnchor?.isActive = true
        //Else if it is the other
        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant:8)
        bubbleTrailingAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        //TextView Constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        //ImageView Constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
