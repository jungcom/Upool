//
//  RideDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/27/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class RideDetailViewController: UIViewController , NVActivityIndicatorViewable{

    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    let db = Firestore.firestore()
    var ridePost : RidePost!
    var driver : UPoolUser?{
        didSet{
            if let url = driver?.profileImageUrl{
                rideDetailView.profileImageView.loadImageUsingCacheWithUrlString(url)
            }
            if let carUrl = driver?.carImageUrl{
                rideDetailView.carPhotoLabel.text = "Car Photo"
                rideDetailView.carImageView.loadImageUsingCacheWithUrlString(carUrl)
            }
        }
    }
    var currentUser : UPoolUser!
    
    //RideDetailView
    let rideDetailView : RideDetailView = {
        let rideDetailView = RideDetailView()
        rideDetailView.messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        rideDetailView.joinRideButton.addTarget(self, action: #selector(handleJoinRide), for: .touchUpInside)
        return rideDetailView
    }()
    
    override func loadView() {
        rideDetailView.dateLabel.text = ridePost.dateString() + " at " + ridePost.timeString()
        rideDetailView.departureCityLabel.text = ridePost.departureCity!
        rideDetailView.destinationCityLabel.text = ridePost.arrivalCity!
        rideDetailView.passengerSeatsLabel.text = "Passengers  \(ridePost.currentPassengers!)/\(ridePost.maxPassengers!)"
        rideDetailView.priceLabel.text = "$\(ridePost.price!)"
        rideDetailView.pickupDetailTextView.text = (ridePost.pickUpDetails == "") ? "None" : ridePost.pickUpDetails
        let cash = ridePost.cashPay ?? true ? "Cash" : ""
        let venmo = ridePost.venmoPay ?? false ? "/ Venmo" : ""
        rideDetailView.driverInfoLabel.text = "Payment: \(cash) \(venmo)"
        view = rideDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ride Details"
        // Do any additional setup after loading the view.
        retrieveCurrentUser()
        retrieveDriver()
    }
    
    func retrieveCurrentUser(){
        db.collection(FirebaseDatabaseKeys.usersKey).document(authUser!.uid).getDocument { (snapShot, err) in
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
        //Don't allow messaging to myself
        guard let fromId = authUser?.uid, let toId = driver?.uid, fromId != toId else {
            return
        }
        let chatlogVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatlogVC.toUser = driver
        navigationController?.pushViewController(chatlogVC, animated: true)
    }
    
    @objc func handleJoinRide(){
        //Don't allow joining my own rides
        guard let fromId = authUser?.uid, let toId = driver?.uid, fromId != toId else {
            return
        }
        
        let alert = UIAlertController(title: "Join Ride?", message: "Are you sure you want to join this ride?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.rideDetailView.joinRideButton.requestedOrJoined(status: Status.pending)
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
        let ref = db.collection(FirebaseDatabaseKeys.rideRequestsKey).document()
        rideRequest.rideRequestId = ref.documentID
        ref.setData(rideRequest.dictionary)
    }
    
    func retrieveDriver(){
        db.collection(FirebaseDatabaseKeys.usersKey).document(ridePost.driverUid!).getDocument { (snapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            } else {
                if let dictionary = snapShot?.data(){
                    self.driver = UPoolUser(dictionary: dictionary)
                    self.rideDetailView.nameLabel.text = "\(self.driver?.firstName ?? "") \(self.driver?.lastName ?? "")"
                    //Check to see if a request exist for this ridePost and user
                    self.checkIfRequestExists()
                } else {
                    self.stopAnimating()
                }
            }
        }
    }
    
    func checkIfRequestExists(){
        let query = db.collection(FirebaseDatabaseKeys.rideRequestsKey)
        query.whereField("fromId", isEqualTo: authUser?.uid ?? "")
             .whereField("ridePostId", isEqualTo: ridePost.ridePostUid ?? "")
             .getDocuments { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                self.stopAnimating()
            } else {
                if let document = snapshot?.documents.first{
                    if let request = RideRequest(dictionary: document.data()){
                        //Set the request button depending on the status
                        if request.requestStatus == 0{
                            self.rideDetailView.joinRideButton.requestedOrJoined(status: Status.pending)
                        } else if request.requestStatus >= 1{
                            self.rideDetailView.joinRideButton.requestedOrJoined(status: Status.confirmed)
                        } else {
                            self.rideDetailView.joinRideButton.requestedOrJoined(status: Status.notAccepted)
                        }
                    }
                }
                self.stopAnimating()
            }
        }
    }
}
