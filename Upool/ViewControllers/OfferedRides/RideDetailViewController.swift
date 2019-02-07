//
//  RideDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class RideDetailViewController: UIViewController {

    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    let db = Firestore.firestore()
    var ridePost : RidePost!
    var driver : UPoolUser?
    var currentUser : UPoolUser!
    
    let scrollView = UIScrollView()
    
    var topContainer = UIView()
    
    // First Top View
    let firstTopView = UIView()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.dateString() + " " + ridePost.timeString()
        label.font = UIFont(name: Fonts.futuraMedium, size: 18)
        return label
    }()
    
    lazy var departureCityLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.departureCity!
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    let rightArrowIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.rightArrow)
        imageView.tintColor = Colors.maroon
        return imageView
    }()
    
    lazy var destinationCityLabel : UILabel = {
        let label = UILabel()
        label.text = ridePost.arrivalCity!
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.maroon
        return label
    }()
    
    var locationStackView : UIStackView!
    
    lazy var passengerSeatsLabel : UILabel = {
        let label = UILabel()
        label.text = "Passengers  \(ridePost.currentPassengers!)/\(ridePost.maxPassengers!)"
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //Second Top View
    let secondTopView = UIView()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.backgroundColor = UIColor.blue
        imageView.tintColor = UIColor.blue
        imageView.image = UIImage(named: "MockProfileImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Robinson Crusoe"
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    let driverInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "\u{2022}Major in Computer Science"
        label.font = UIFont(name: Fonts.futura, size: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$\(ridePost.price!)"
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = Colors.moneyGreen
        return label
    }()
    
    //Third Top View
    let thirdTopView = UIView()
    
    let pickUpLabel : UILabel = {
        let label = UILabel()
        label.text = "Pickup Details"
        label.font = UIFont(name: Fonts.futura, size: 17)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var pickupDetailTextView : UITextView = {
        let label = UITextView()
        label.text = (ridePost.pickUpDetails == "") ? ridePost.pickUpDetails : "None"
        label.font = UIFont(name: Fonts.futura, size: 14)
        label.textColor = UIColor.gray
        label.isEditable = false
        label.isScrollEnabled = false
        return label
    }()
    
    //Fourth Top view
    let buttonView = UIView()
    
    var buttonStackView : UIStackView!
    
    let messageButton : UIButton = {
        let button = UIButton()
        button.setTitle("MESSAGE", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 18)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.maroon.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        return button
    }()
    
    let joinRideButton : UIButton = {
        let button = UIButton()
        button.setTitle("JOIN RIDE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helvetica, size: 17)
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleJoinRide), for: .touchUpInside)
        return button
    }()
    
    //Bottom Container
    
    let bottomContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        retrieveCurrentUser()
        retrieveDriver()
    }
    
    func retrieveCurrentUser(){
        db.collection("users").document(authUser!.uid).getDocument { (snapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            } else {
                if let dictionary = snapShot?.data(){
                    self.currentUser = UPoolUser(dictionary: dictionary)
                }
            }
        }
    }
    
    @objc func handleMessage(){
        let chatlogVC = ChatLogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatlogVC, animated: true)
    }
    
    @objc func handleJoinRide(){
        let alert = UIAlertController(title: "Join Ride?", message: "Are you sure you want to join this ride?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.joinRideButton.requestedOrJoined(joined: false)
            self.sendRequestToDriver()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func sendRequestToDriver(){
        let rideRequest = RideRequest()
        rideRequest.fromId = currentUser.uid
        rideRequest.toDriverId = driver?.uid
        rideRequest.timeStamp = Date()
        rideRequest.requestStatus = 0
        rideRequest.ridePostId = ridePost.ridePostUid
        rideRequest.fromIdFirstName = currentUser.firstName
        db.collection("rideRequests").addDocument(data: rideRequest.dictionary)
    }
    
    func retrieveDriver(){
        db.collection("users").document(ridePost.driverUid!).getDocument { (snapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            } else {
                if let dictionary = snapShot?.data(){
                    self.driver = UPoolUser(dictionary: dictionary)
                    self.nameLabel.text = "\(self.driver?.firstName ?? "") \(self.driver?.lastName ?? "")"
                    //TODO : Set User Profile Image
                    
                    //Check to see if a request exist for this ridePost and user
                    self.checkIfRequestExists()
                } else {
                    print("driver not found")
                }
            }
        }
    }
    
    func checkIfRequestExists(){
        let query = db.collection("rideRequests")
        query.whereField("fromId", isEqualTo: authUser?.uid ?? "")
             .whereField("ridePostId", isEqualTo: ridePost.ridePostUid ?? "")
             .getDocuments { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                if let document = snapshot?.documents.first{
                    print("\(document.documentID) => \(document.data())")
                    if let request = RideRequest(dictionary: document.data()){
                        //Set the request button depending on the status
                        if request.requestStatus == 0{
                            self.joinRideButton.requestedOrJoined(joined: false)
                        } else if request.requestStatus == 1{
                            self.joinRideButton.requestedOrJoined(joined: true)
                        }
                    }
                }
            }
        }
    }
}
