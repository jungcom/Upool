//
//  UIView.swift
//  Upool
//
//  Created by Anthony Lee on 1/28/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension UIView{
    static func dropShadow(view : UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 4.0
        view.layer.cornerRadius = 5.0
    }
    
    func addGrayBottomBorder(view: UIView, multiplier: CGFloat){
        self.backgroundColor = UIColor.gray
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        self.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

extension UIButton{
    func requestedOrJoined(joined : Bool){
        if joined{
            self.setTitle("Ride Joined ", for: .normal)
        } else {
            self.setTitle("Requested ", for: .normal)
        }
        self.setImage(UIImage(named: "CheckMark"), for: .normal)
        self.setTitleColor(Colors.maroon, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 17)
        self.backgroundColor = UIColor.white
        self.isEnabled = false
    }
}
