//
//  UICollectionView.swift
//  Upool
//
//  Created by Anthony Lee on 2/19/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit
extension UICollectionView {
    
    //Set a message when CollectionViews are Empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: Fonts.helvetica, size: 22)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView{
    //Set a message when CollectionViews are Empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: Fonts.helvetica, size: 22)
        messageLabel.sizeToFit()
        
        self.separatorStyle = .none
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.separatorStyle = .singleLine
        self.backgroundView = nil
    }
}
