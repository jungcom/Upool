//
//  ProfileViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/6/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setupNavBar()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out Failed")
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
