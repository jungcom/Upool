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

class ProfileViewController: UIViewController, NVActivityIndicatorViewable {

    let db = Firestore.firestore()
    private var authUser : User?{
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
        view.backgroundColor = UIColor.white
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

// MARK : ImagePicker Protocol
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func handleImageSelection(){
        startActivity()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: {
            self.stopAnimating()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        startActivity()
        var selectedImage : UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        } else {
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if let selectedImage = selectedImage{
            profileView.profileImageView.image = selectedImage
        }
        
        //save image to firebase storage
        saveProfileImageToFirebaseStorage()
        dismiss(animated: true, completion: {
            self.stopAnimating()
        })
    }
    
    func saveProfileImageToFirebaseStorage(){
        guard let id = authUser?.uid else {return}
        
        let storage = Storage.storage().reference().child("profileImages").child(id)
        if let profileImage = self.profileView.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.05) {
            storage.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                storage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    guard let url = url else { return }
                    let urlString = url.absoluteString
                    self.updateUserProfileImageUrl(id, urlString)
                })
            }
        }
    }
    
    func updateUserProfileImageUrl(_ uid : String, _ url : String){
        let data = ["profileImageUrl" : url]
        db.collection("users").document(uid).updateData(data) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
