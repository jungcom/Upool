//
//  UIView.swift
//  Upool
//
//  Created by Anthony Lee on 1/28/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension UIView{
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
    
    static func dropShadow(view : UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 4.0
        view.layer.cornerRadius = 5.0
    }
    
    func addGrayBottomBorderTo(view: UIView, multiplier: CGFloat, bottom:Bool, centered: Bool, color: UIColor){
        self.backgroundColor = color
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if bottom{
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        if centered {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        }
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        self.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

extension UIButton{
    func requestedOrJoined(status : Status){
        if status == Status.confirmed{
            self.setTitle("Ride Joined ", for: .normal)
            self.setImage(UIImage(named: "CheckMark"), for: .normal)
        } else if status == Status.pending {
            self.setTitle("Requested ", for: .normal)
            self.setImage(UIImage(named: "CheckMark"), for: .normal)
        } else {
            self.setTitle("Declined", for: .normal)
        }
        self.setTitleColor(Colors.maroon, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 17)
        self.backgroundColor = UIColor.white
        self.isEnabled = false
    }
}

extension UITextField{
    static func getTextField(_ string : String) -> UITextField{
        let textField = UITextField()
        textField.placeholder = string
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.backgroundColor = UIColor.white
        textField.autocapitalizationType = .none
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }
    
    func addLeftPadding(){
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
