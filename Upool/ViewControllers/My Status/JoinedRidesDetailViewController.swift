//
//  JoinedRidesDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 3/10/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class JoinedRidesDetailViewController: UIViewController{
    
    let db = Firestore.firestore()
    
    var ridePost : RidePost!
    
    var acceptedPassengerRequests = [RideRequest]()
    
    let joinedRidesDetailView : JoinedRidesDetailView = {
        let view = JoinedRidesDetailView()
        return view
    }()
    
    override func loadView() {
        joinedRidesDetailView.dateLabel.text = ridePost.dateString() + " at " + ridePost.timeString()
        joinedRidesDetailView.departureCityLabel.text = ridePost.departureCity!
        joinedRidesDetailView.destinationCityLabel.text = ridePost.arrivalCity!
        joinedRidesDetailView.priceLabel.text = "$\(ridePost.price!)"
        joinedRidesDetailView.pickupDetailTextView.text = (ridePost.pickUpDetails == "") ? "None" : ridePost.pickUpDetails
        setDriverProfileImageAndName()
        view = joinedRidesDetailView
    }
    
    func setDriverProfileImageAndName(){
        guard let driverId = ridePost.driverUid else { return }
        db.collection(FirebaseDatabaseKeys.usersKey).document(driverId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            if let data = snapshot.data(), let driver = UPoolUser(dictionary: data){
                self.joinedRidesDetailView.driverNameLabel.text = "\(driver.firstName!)"
                guard let profileImageUrl = driver.profileImageUrl else {return}
                self.joinedRidesDetailView.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ride Details"
        joinedRidesDetailView.passengersCollectionView.delegate = self
        joinedRidesDetailView.passengersCollectionView.dataSource = self
        retrievePassengerRequests()
    }
    
    func retrievePassengerRequests(){
        acceptedPassengerRequests.removeAll()
        
        db.collection(FirebaseDatabaseKeys.rideRequestsKey).whereField("ridePostId", isEqualTo: ridePost.ridePostUid!).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    if let request = RideRequest(dictionary: document.data()){
                        if request.requestStatus == Status.confirmed.rawValue{
                            print("Confirmed Passenger Requests : \(document.documentID) => \(document.data())")
                            self.acceptedPassengerRequests.append(request)
                        }
                    }
                }
                self.joinedRidesDetailView.passengersCollectionView.reloadData()
            }
        })
    }
}

extension JoinedRidesDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ridePost.maxPassengers ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: acceptedPassengerCellId, for: indexPath) as! AcceptedPassengerCollectionViewCell
        if indexPath.row < acceptedPassengerRequests.count {
            cell.rideRequest = acceptedPassengerRequests[indexPath.row]
        } else {
            //set cell to empty
            cell.empty = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //Center the Passenger Cells
        let cellNumber = CGFloat(ridePost.maxPassengers ?? 4)
        let totalCellWidth = collectionView.frame.width * 0.20 * cellNumber
        let totalSpacingWidth =  CGFloat(15.0 * (cellNumber - 1))
        let leftInset = (collectionView.frame.width - (totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
                
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.20, height: collectionView.frame.height)

    }
}
