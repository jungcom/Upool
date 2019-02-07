//
//  OfferedRides.swift
//  Upool
//
//  Created by Anthony Lee on 1/31/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

extension OfferedRidesCollectionViewController{
    func setupNavBar() {
        //TitleLogo
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(createRide))
        UINavigationBar.appearance().barTintColor = Colors.maroon
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
    }
}
