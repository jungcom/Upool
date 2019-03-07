//
//  ChatLogView.swift
//  Upool
//
//  Created by Anthony Lee on 3/6/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class ChatLogView : UIView{
    
    //move input Bottom view
    var inputBottomAnchor : NSLayoutConstraint?
    
    //MARK : Input Text Views
    lazy var containerView : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        return container
    }()
    
    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        return button
    }()
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    lazy var bottomSafeArea : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInputView(){
        
        addSubview(containerView)
        addSubview(bottomSafeArea)
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        //SafeArea View
        bottomSafeArea.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeArea.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomSafeArea.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomSafeArea.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        //variable for bottom anchor of bottomSafeAreaView
        inputBottomAnchor = bottomSafeArea.bottomAnchor.constraint(equalTo: bottomAnchor)
        inputBottomAnchor!.isActive = true
        
        //Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomSafeArea.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //Button Contraints
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier:0.2).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        //Button Contraints
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        //separator line
        let topLine = UIView()
        containerView.addSubview(topLine)
        topLine.addGrayBottomBorderTo(view: containerView, multiplier: 1.0, bottom: false, centered: true, color: Colors.maroon)
    }
}
