//
//  ProfileSettingsTableViewNotificationCell.swift
//  Upool
//
//  Created by Anthony Lee on 3/13/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import UserNotifications

class ProfileSettingsTableViewNotificationCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        print("cell initialized")
        self.selectionStyle = .none
        setupLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        self.textLabel?.text = "Push Notifications"
        self.textLabel?.textColor = UIColor.lightGray
        self.textLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
    }
}
