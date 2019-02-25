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
            print("dideSet")
            guard let thisUser = thisUser else {return}
            if let url = thisUser.profileImageUrl{
                profileImageView.loadImageUsingCacheWithUrlString(url)
                profileImageView.layer.cornerRadius = 30
                profileImageView.layer.masksToBounds = true
            }
            self.nameLabel.text = "\(thisUser.firstName ?? "") \(thisUser.lastName ?? "" )"
            self.userFirstName.subjectTextField.text = "\(thisUser.firstName ?? "" )"
            self.userLastName.subjectTextField.text = "\(thisUser.lastName ?? "" )"
            self.userGradYear.subjectTextField.text = "\(thisUser.gradYear ?? "" )"
            self.userMajor.subjectTextField.text = "\(thisUser.major ?? "" )"
            self.userAge.subjectTextField.text = "\(thisUser.age ?? "" )"
            self.userGender.subjectTextField.text = "\(thisUser.gender ?? "" )"
            
        }
    }
    
    //MARK : UI Properties
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize.height = 1000
        return scrollView
    }()
    
    //TopProfileImageContainer
    let profileImageAndNameContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "AddProfileImage")
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFill
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = Colors.maroon
        label.font = UIFont(name: Fonts.helvetica, size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //Container About the User
    let aboutContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    let aboutLabel : UILabel = {
        let label = UILabel()
        label.text = "About"
        label.textColor = UIColor.gray
        label.font = UIFont.init(name: Fonts.helvetica, size: 20)
        return label
    }()
    
    var isEditingInfo : Bool = false {
        didSet{
            if isEditingInfo{
                pencilEditButton.setTitle("Save", for: .normal)
                pencilEditButton.setImage(nil, for: .normal)
                let userInfoFields = userInfoStackView.subviews as! [UserInfoField]
                for userInfoField in userInfoFields{
                    userInfoField.isUserInteractionEnabled = true
                }
            } else {
                let alert = UIAlertController(title: "Save", message: "Are you sure you want to save these changes?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
                    //Set alert view to make sure to save user info
                    self.pencilEditButton.setImage(UIImage(named: "PencilEdit"), for: .normal)
                    self.pencilEditButton.setTitle("", for: .normal)
                    let userInfoFields = self.userInfoStackView.subviews as! [UserInfoField]
                    for userInfoField in userInfoFields{
                        userInfoField.isUserInteractionEnabled = false
                    }
                    self.saveUserInfoToDatabase()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    let pencilEditButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PencilEdit"), for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handlePencilEdit), for: .touchUpInside)
        return button
    }()
    
    //StackView for UserInfo
    
    let userInfoUIView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        UIView.dropShadow(view: view)
        return view
    }()
    
    var userInfoStackView : UIStackView!
    
    let userFirstName : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "First Name"
        userInfo.subjectTextField.placeholder = "First Name"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userLastName : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Last Name"
        userInfo.subjectTextField.placeholder = "Last Name"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userGradYear : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Grad Year"
        userInfo.subjectTextField.placeholder = "Your Graduation Year"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userMajor : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Major"
        userInfo.subjectTextField.placeholder = "Major"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userAge : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Age"
        userInfo.subjectTextField.placeholder = "Age"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    let userGender : UserInfoField = {
        let userInfo = UserInfoField()
        userInfo.subjectLabel.text = "Gender"
        userInfo.subjectTextField.placeholder = "Gender"
        userInfo.isUserInteractionEnabled = false
        return userInfo
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setupNavBar()
        setupScrollBar()
        setupProfileImageAndNameContainer()
        setupAboutContainer()
        retrieveUserData()
    }
    
    func retrieveUserData(){
        if let user = authUser{
            db.collection("users").document(user.uid).getDocument { (snapshot, error) in
                guard let snapshot = snapshot, let dict = snapshot.data() else {return}
                print("retrive data")
                if let user = UPoolUser(dictionary: dict){
                    self.thisUser = user
                }
            }
        }
    }
    
    //Save user information to database
    func saveUserInfoToDatabase(){
        guard let userId = thisUser?.uid else {return}
        var userInfo = [String : Any]()
        userInfo["firstName"] = userFirstName.subjectTextField.text
        userInfo["lastName"] = userLastName.subjectTextField.text
        userInfo["gradYear"] = userGradYear.subjectTextField.text
        userInfo["major"] = userMajor.subjectTextField.text
        userInfo["age"] = userAge.subjectTextField.text
        userInfo["gender"] = userGender.subjectTextField.text
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
    
    @objc func handleLogout(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Log Out", style: .default) { (_) in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign Out Failed")
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
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

//Keyboard Notifications
extension ProfileViewController{
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
}
