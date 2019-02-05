//
//  myStatusViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/30/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

private let offeredRidesCellId = "Cell"
private let headerCellId = "HeaderForMyStatus"

class MyStatusViewController: UICollectionViewController {
    
    private var authUser : User!{
        return Auth.auth().currentUser
    }
    
    let db = Firestore.firestore()
    
    var refresher : UIRefreshControl!
    
    var isMyRides : Bool = true
    
    var myRidePosts = [RidePost]()
    var myRequests = [RideRequest]()
    var joinedRidePosts = [RidePost]()
    var pendingRidePosts = [RidePost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(OfferedRidesCollectionViewCell.self, forCellWithReuseIdentifier: offeredRidesCellId)
        self.collectionView.register(MyStatusSectionHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        // Do any additional setup after loading the view.
        setupNavBar()
        retrieveMyRidePosts()
        retrieveMyRequestedRidePosts()
        addRefresher()
    }
    
    @objc func retrieveMyRidePosts(){
        //Reset Posts
        self.myRidePosts.removeAll()
        
        //Retrieve Data
        let docRef = db.collection("ridePosts")
        
        docRef.order(by: "departureDate", descending: false).whereField("driverUid", isEqualTo: authUser.uid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.myRidePosts.append(post)
                    }
                }
                self.collectionView.reloadData()
                self.endRefresher()
            }
        }
    }
    
    @objc func retrieveMyRequestedRidePosts(){
        //Reset Posts
        self.joinedRidePosts.removeAll()
        self.pendingRidePosts.removeAll()
        self.myRequests.removeAll()
        
        //Retrieve Request Data
        let docRef = db.collection("rideRequests")
        
        docRef.order(by: "timeStamp", descending: false).whereField("fromId", isEqualTo: authUser.uid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let request = RideRequest(dictionary: document.data()){
                        self.myRequests.append(request)
                    }
                }
                self.retrieveJoinedAndPendingRidePosts()
            }
        }
    }
    
    @objc func retrieveJoinedAndPendingRidePosts(){
        
        //Retrieve Ride Data for each request
        for request in myRequests{
            db.collection("ridePosts").document(request.ridePostId).getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let post = RidePost(dictionary: (snapshot?.data())!){
                        if request.requestStatus == 0{
                            self.pendingRidePosts.append(post)
                        } else if request.requestStatus == 1{
                            self.joinedRidePosts.append(post)
                        }
                    }
                    self.collectionView.reloadData()
                    self.endRefresher()
                }
            })
        }
    }
    
    func addRefresher(){
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(retrieveMyRidePosts), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    func endRefresher(){
        if let refresher = self.refresher{
            refresher.endRefreshing()
        }
    }
}


// MARK: UICollectionViewDataSource
extension MyStatusViewController : UICollectionViewDelegateFlowLayout{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyRides{
            return myRidePosts.count
        } else {
            return joinedRidePosts.count + pendingRidePosts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isMyRides{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
            cell.backgroundColor = UIColor.white
            cell.post = myRidePosts[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
            cell.backgroundColor = UIColor.white
            if indexPath.row >= joinedRidePosts.count{
                cell.post = pendingRidePosts[indexPath.row - joinedRidePosts.count]
            } else {
                cell.post = joinedRidePosts[indexPath.row]
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            return CGSize(width: view.frame.width * 0.9, height: 200)
        default:
            return CGSize(width: view.frame.width * 0.9, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    //Collectionview Header delegates
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! MyStatusSectionHeaderCell
        header.segmentTapped = { (index) in
            if index == 0{
                print("My Rides")
                self.isMyRides = true
                collectionView.reloadData()
            } else {
                print("Pending Rides")
                self.isMyRides = false
                collectionView.reloadData()
            }
        }
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
