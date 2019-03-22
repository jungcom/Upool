//
//  AboutPageViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/21/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController{
    
    let aboutPageImageView : UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "AboutPage"))
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = UIColor.init(red: 106/255, green: 8/255, blue: 8/255, alpha: 1)
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationItem.title = "About"
        
        view.addSubview(aboutPageImageView)
        aboutPageImageView.translatesAutoresizingMaskIntoConstraints = false
        aboutPageImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        aboutPageImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        aboutPageImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        aboutPageImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
