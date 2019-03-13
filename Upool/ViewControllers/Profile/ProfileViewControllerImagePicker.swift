//
//  ProfileViewControllerImagePicker.swift
//  Upool
//
//  Created by Anthony Lee on 3/11/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

// MARK : ImagePicker Protocol
import UIKit
import Firebase

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
