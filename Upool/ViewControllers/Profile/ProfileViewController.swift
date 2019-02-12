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
    
    var thisUser : UPoolUser? {
        didSet{
            if let url = thisUser?.profileImageUrl{
                profileImageView.loadImageUsingCacheWithUrlString(url)
                profileImageView.layer.cornerRadius = 8
                profileImageView.layer.masksToBounds = true
            }
        }
    }
    
    lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "AddProfileImage")
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFill
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setupNavBar()
        setupProfileImage()
        retrieveUserData()
    }
    
    func retrieveUserData(){
        if let user = authUser{
            db.collection("users").document(user.uid).getDocument { (snapshot, error) in
                guard let snapshot = snapshot, let dict = snapshot.data() else {return}
                if let user = UPoolUser(dictionary: dict){
                    self.thisUser = user
                }
            }
        }
    }
    
    func setupProfileImage(){
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
    }
    
    func startActivity(){
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out Failed")
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
        //present(LoginViewController(), animated: true)
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
            profileImageView.image = selectedImage
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
        if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.05) {
            storage.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                storage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error)
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
