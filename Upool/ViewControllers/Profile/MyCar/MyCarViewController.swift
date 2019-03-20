//
//  MyCarViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/20/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import NVActivityIndicatorView

class MyCarViewController : UIViewController, NVActivityIndicatorViewable{

    let db = Firestore.firestore()
    var authUser : User?{
        return Auth.auth().currentUser
    }
    
    var thisUser : UPoolUser? {
        didSet{
            guard let thisUser = thisUser else {return}
            if let url = thisUser.carImageUrl{
                //carImageView.loadImageUsingCacheWithUrlString(url)
            }
        }
    }
    
    lazy var carImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "CarPlaceHolder")
        image.backgroundColor = UIColor.clear
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.layer.borderColor = Colors.maroon.cgColor
        image.layer.borderWidth = 0.5
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.groupTableViewBackground
        navigationItem.title = "Edit My Car"
        
        view.addSubview(carImageView)
        
        //ProfileImageView Constraints
        carImageView.translatesAutoresizingMaskIntoConstraints = false
        carImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        carImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        carImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        carImageView.heightAnchor.constraint(equalTo: carImageView.widthAnchor).isActive = true
    }
}

extension MyCarViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func handleImageSelection(){
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
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
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        var selectedImage : UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        } else {
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if let selectedImage = selectedImage{
            carImageView.image = selectedImage
        }
        
        //save image to firebase storage
        saveCarImageToFirebaseStorage()
        dismiss(animated: true, completion: {
            self.stopAnimating()
        })
    }
    
    func saveCarImageToFirebaseStorage(){
        guard let id = authUser?.uid else {return}
        
        let storage = Storage.storage().reference().child("CarImages").child(id)
        if let profileImage = self.carImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.05) {
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
        let data = [FirebaseDatabaseKeys.UserFieldKeys.carImageUrl : url]
        db.collection(FirebaseDatabaseKeys.usersKey).document(uid).updateData(data) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
