//
//  Profile.swift
//  Upool
//
//  Created by Anthony Lee on 2/6/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit

extension ProfileViewController{
    func setupNavBar() {
        
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))

    }
    
    func setupProfileImageAndNameContainer(){
        view.addSubview(profileImageAndNameContainer)
        profileImageAndNameContainer.backgroundColor = UIColor.groupTableViewBackground
        profileImageAndNameContainer.translatesAutoresizingMaskIntoConstraints = false
        profileImageAndNameContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileImageAndNameContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileImageAndNameContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileImageAndNameContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.3).isActive = true
        
        profileImageAndNameContainer.addSubview(profileImageView)
        profileImageAndNameContainer.addSubview(nameLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: profileImageAndNameContainer.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: profileImageAndNameContainer.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageAndNameContainer.widthAnchor, multiplier: 0.3).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
}
