//
//  ChatMessageCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/8/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell{
    
    var message : Message? {
        didSet{
            textView.text = message?.text
        }
    }
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        return textView
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.maroon
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        addSubview(bubbleView)
        addSubview(textView)
    }
    
    func setupConstraints(){
        //Bubble Constraints
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        //TextView Constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
