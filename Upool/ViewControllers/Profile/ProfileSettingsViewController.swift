//
//  ProfileSettingsViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/12/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

private let profileTableViewCellId = "profileTableViewCell"

class ProfileSettingsViewController : UIViewController{
    
    let profileSettingsView : ProfileSettingsView = {
        let view = ProfileSettingsView()
        return view
    }()
    
    override func loadView() {
        profileSettingsView.settingsTableView.delegate = self
        profileSettingsView.settingsTableView.dataSource = self
        profileSettingsView.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: profileTableViewCellId)
        view = profileSettingsView
        navigationItem.title = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ProfileSettingsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileTableViewCellId, for: indexPath)
        cell.textLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
        cell.textLabel?.textColor = UIColor.gray
        cell.accessoryView = UIImageView(image: UIImage(named: "SmallRightArrow"))
        cell.accessoryView?.tintColor = Colors.maroon
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "About"
        case 1:
            cell.textLabel?.text = "Terms & Conditions"
        case 2:
            cell.textLabel?.text = "Privacy Policy"
        case 3:
            cell.textLabel?.text = "Contact"
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Settings Selected in : \(indexPath.row)")
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            let privacyPolicyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
        case 3:
            break
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat {
        return 50
    }
}
