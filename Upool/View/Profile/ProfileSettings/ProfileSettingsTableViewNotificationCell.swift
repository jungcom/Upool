//
//  ProfileSettingsTableViewNotificationCell.swift
//  Upool
//
//  Created by Anthony Lee on 3/13/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class ProfileSettingsTableViewNotificationCell: UITableViewCell {

    let toggle : UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = Colors.maroon
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("cell initialized")
        setupToggle()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupToggle(){
        addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        toggle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        toggle.widthAnchor.constraint(equalTo: widthAnchor, multiplier:0.2).isActive = true
    }
    
    func setupLabel() {
        self.textLabel?.text = "Push Notifications"
        self.textLabel?.textColor = UIColor.lightGray
        self.textLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
    }
}
