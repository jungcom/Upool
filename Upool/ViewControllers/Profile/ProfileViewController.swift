//
//  ProfileViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/6/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

private let profileTableViewCellId = "profileTableViewCell"
class ProfileViewController: UIViewController, NVActivityIndicatorViewable {

    let db = Firestore.firestore()
    var authUser : User?{
        return Auth.auth().currentUser
    }
    
    //ProfileView
    var profileView : ProfileView!
    
    var isEditingInfo : Bool = false {
        didSet{
            if isEditingInfo{
                profileView.pencilEditButton.setTitle("Save", for: .normal)
                profileView.pencilEditButton.setImage(nil, for: .normal)
                let userInfoFields = profileView.userInfoStackView.subviews as! [UserInfoField]
                for userInfoField in userInfoFields{
                    userInfoField.isUserInteractionEnabled = true
                }
            } else {
                let alert = UIAlertController(title: "Save", message: "Are you sure you want to save these changes?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
                    //Set alert view to make sure to save user info
                    self.profileView.pencilEditButton.setImage(UIImage(named: "PencilEdit"), for: .normal)
                    self.profileView.pencilEditButton.setTitle("", for: .normal)
                    let userInfoFields = self.profileView.userInfoStackView.subviews as! [UserInfoField]
                    for userInfoField in userInfoFields{
                        userInfoField.isUserInteractionEnabled = false
                    }
                    self.saveUserInfoToDatabase()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        setupProfileView()
        retrieveUserData()
    }
    
    fileprivate func setupNavBar() {
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func setupProfileView() {
        profileView = ProfileView()
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        profileView.pencilEditButton.addTarget(self, action: #selector(handlePencilEdit), for: .touchUpInside)
        profileView.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
        
    }
    
    func retrieveUserData(){
        if let user = authUser{
            db.collection("users").document(user.uid).getDocument { (snapshot, error) in
                guard let snapshot = snapshot, let dict = snapshot.data() else {return}
                print("retrive data")
                if let user = UPoolUser(dictionary: dict){
                    self.profileView.thisUser = user
                }
            }
        }
    }
    
    //Save user information to database
    func saveUserInfoToDatabase(){
        guard let userId = profileView.thisUser?.uid else {return}
        var userInfo = [String : Any]()
        userInfo["firstName"] = profileView.userFirstName.subjectTextField.text
        userInfo["lastName"] = profileView.userLastName.subjectTextField.text
        userInfo["gradYear"] = profileView.userGradYear.subjectTextField.text
        userInfo["major"] = profileView.userMajor.subjectTextField.text
        userInfo["age"] = profileView.userAge.subjectTextField.text
        userInfo["gender"] = profileView.userGender.subjectTextField.text
        db.collection("users").document(userId).setData(userInfo, merge: true) { (err) in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("UserInfo successfully written and saved!")
            }
        }
    }
    
    func startActivity(){
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
    }
    
    @objc func handlePencilEdit(){
        print("Handle Edit")
        if isEditingInfo{
            isEditingInfo = false
        } else {
            isEditingInfo = true
        }
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
    
    @objc func handleSettingsButton(){
        
    }
    
    @objc func handleLogout(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Log Out", style: .default) { (_) in
            let currentUserId = self.authUser?.uid
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign Out Failed")
            }
            if let currentUserId = currentUserId{
                print(currentUserId)
                let noFcmToken = ["fcmToken": ""]
                self.db.collection("users").document(currentUserId).updateData(noFcmToken)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(signOutAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
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
            cell.textLabel?.text = "Help"
        case 2:
            cell.textLabel?.text = "Terms & Conditions"
        case 3:
            cell.textLabel?.text = "Contact"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude);
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Settings Selected in : \(indexPath.row)")
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat {
        return tableView.frame.height/4
    }
}
