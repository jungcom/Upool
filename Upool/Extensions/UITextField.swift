//
//  UITextField.swift
//  Upool
//
//  Created by Anthony Lee on 1/23/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension UITextField{
    static func getTextField(_ string : String) -> UITextField{
        let textField = UITextField()
        textField.placeholder = string
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.backgroundColor = UIColor.white
        return textField
    }
}
