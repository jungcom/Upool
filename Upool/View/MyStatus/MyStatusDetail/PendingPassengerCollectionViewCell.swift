//
//  PendingPassengerViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 2/19/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class PendingPassengerCollectionViewCell: UICollectionViewCell {
    
    var declineButtonTapped : (() -> ())?
    var acceptButtonTapped : (() -> ())?
    
    let db = Firestore.firestore()
    var ridePost : RidePost?
    var rideRequest : RideRequest? {
        didSet{
            //Retrieve the requesting user data and show the name and profile image of that user
            if let request = rideRequest, let requestingUserId = request.fromId{
                db.collection(FirebaseDatabaseKeys.usersKey).document(requestingUserId).getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else {return}
                    if let data = snapshot.data(), let requestingUser = UPoolUser(dictionary: data){
                        self.nameLabel.text = "\(requestingUser.firstName!) \(requestingUser.lastName!) wants to join your ride"
                        guard let profileImageUrl = requestingUser.profileImageUrl else {return}
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
            }
        }
    }
    
    lazy var nameLabel :UILabel = {
        let label = UILabel()
        label.text = "Bob Marley wants to join your ride"
        label.textColor = UIColor.gray
        label.font = UIFont(name: Fonts.helvetica, size: 12)
        label.textAlignment = .left
        return label
    }()

    lazy var profileImageView :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ProfileImagePlaceholder")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()

    lazy var declineButton : UIButton = {
        let button = UIButton()
        button.setTitle("DECLINE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
        return button
    }()
    
    lazy var acceptButton : UIButton = {
        let button = UIButton()
        button.setTitle("ACCEPT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 12)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.white
        setupConstraints()
        UIView.dropShadow(view: self)
    }
    
    func setupConstraints(){
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(declineButton)
        addSubview(acceptButton)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -8).isActive = true
        acceptButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        declineButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant:-8).isActive = true
        declineButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Button handlers
    @objc func handleDecline(){
        print("Decline")
        let alert = UIAlertController(title: "Decline Request", message: "Are you sure you want to decline this passenger?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let declineAction = UIAlertAction(title: "Decline", style: .default) { (_) in
            if let request = self.rideRequest{
                //Call Clound function to send notification to the user
                self.callCloudFunctionToSendNotification(toUserId: request.fromId, accepted: false)
                
                //Update the request status to confirmed
                self.db.collection(FirebaseDatabaseKeys.rideRequestsKey).document(request.rideRequestId).updateData(["requestStatus":Status.notAccepted.rawValue])
            }
            //Execute Closure
            self.declineButtonTapped?()
        }
        alert.addAction(cancelAction)
        alert.addAction(declineAction)
        self.parentViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func handleAccept(){
        print("Accept")
        let alert = UIAlertController(title: "Accept Request", message: "Are you sure you want to accept this passenger?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) in
            if let request = self.rideRequest{
                //Call Clound function to send notification to the user
                self.callCloudFunctionToSendNotification(toUserId: request.fromId, accepted: true)
                
                //Update the request status to confirmed
                self.db.collection(FirebaseDatabaseKeys.rideRequestsKey).document(request.rideRequestId).updateData(["requestStatus":Status.confirmed.rawValue], completion: { (error) in
                    //Execute Closure
                    self.acceptButtonTapped?()
                })
                
                //Update the ridePost's Current passengers to +1
                guard let ridePost = self.ridePost, let ridePostUid = ridePost.ridePostUid else {return}
                self.db.collection(FirebaseDatabaseKeys.ridePostsKey).document(ridePostUid).getDocument(completion: { (snapshot, error) in
                    guard let snapshot = snapshot, let data = snapshot.data() else {return}
                    if let retrievedRidePost = RidePost(dictionary: data), let current = retrievedRidePost.currentPassengers{
                        self.db.collection(FirebaseDatabaseKeys.ridePostsKey).document(ridePostUid).updateData(["currentPassengers" : (current+1)])
                    }
                })
                
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func callCloudFunctionToSendNotification(toUserId : String, accepted : Bool) {
        //Call Cloud function to send notification to user
        let data = ["accepted": accepted, "toUserId" : toUserId] as [String : Any]
        Functions.functions().httpsCallable("rideRequestAcceptedOrDeclined").call(data) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
                // ...
            }
//            if let text = (result?.data as? [String: Any])?["text"] as? String {
//                //Do something with the returned value
//            }
        }
    }
}
