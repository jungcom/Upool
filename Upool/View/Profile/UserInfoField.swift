//
//  UserInfoField.swift
//  Upool
//
//  Created by Anthony Lee on 2/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class UserInfoField: UIView {
    
    let subjectLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        label.textColor = .lightGray
        return label
    }()
    
    let subjectTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: Fonts.helvetica, size: 18)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(subjectLabel)
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel.topAnchor.constraint(equalTo: topAnchor, constant:5).isActive = true
        subjectLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:5).isActive = true
        subjectLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        subjectLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(subjectTextField)
        subjectTextField.translatesAutoresizingMaskIntoConstraints = false
        subjectTextField.topAnchor.constraint(equalTo: topAnchor, constant:5).isActive = true
        subjectTextField.leadingAnchor.constraint(equalTo: subjectLabel.trailingAnchor).isActive = true
        subjectTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subjectTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }

}
