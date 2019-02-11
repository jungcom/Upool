//
//  ChatLog.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension ChatLogViewController{
    
    func setupInitialUI(){
        //keyboard setup
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tap)
        
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func setupInputView(){
        
        view.addSubview(containerView)
        view.addSubview(bottomSafeArea)
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        //SafeArea View
        bottomSafeArea.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomSafeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomSafeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //variable for bottom anchor of bottomSafeAreaView
        inputBottomAnchor = bottomSafeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputBottomAnchor!.isActive = true
        
        //Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomSafeArea.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //Button Contraints
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.2).isActive = true
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
