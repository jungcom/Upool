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
private let headerDeleteCellId = "headerDeleteCell"

class MyStatusViewController: UICollectionViewController  {
    
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
    
    lazy var segmentControl : UISegmentedControl = {
        let titles = ["My Rides","Joined Rides"]
        let segment = UISegmentedControl(items: titles)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.white
        segment.tintColor = Colors.maroon
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 16)!]
        segment.setTitleTextAttributes(stringAtt, for: .normal)
        segment.addTarget(self, action: #selector(segmentTappedFunc), for: .valueChanged)
        return segment
    }()
    
    @objc func segmentTappedFunc(){
        isMyRides = segmentControl.selectedSegmentIndex == 0 ? true : false
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(OfferedRidesCollectionViewCell.self, forCellWithReuseIdentifier: offeredRidesCellId)
        self.collectionView.register(MyStatusTrashCanHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerDeleteCellId)
        
        // Do any additional setup after loading the view.
        setupNavBar()
        setupSegmentControlAndCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveMyRidePosts()
        retrieveMyRequestedRidePosts()
    }
    
    @objc func retrieveMyRidePosts(){
        //Reset Posts
        self.myRidePosts.removeAll()
        
        //Retrieve Data
        let docRef = db.collection("ridePosts")
        
        docRef.order(by: "departureDate", descending: false).whereField("departureDate", isGreaterThan: Date().timeIntervalSinceReferenceDate).whereField("driverUid", isEqualTo: authUser.uid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("My Ride Posts : \(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.myRidePosts.append(post)
                    }
                }
                self.collectionView.reloadData()
                //self.endRefresher()
            }
        }
    }
    
    @objc func retrieveMyRequestedRidePosts(){
        
        //Retrieve Request Data
        let docRef = db.collection("rideRequests")
        
        docRef.order(by: "timeStamp", descending: false).whereField("fromId", isEqualTo: authUser.uid).getDocuments { (querySnapshot, err) in
            //reset my Requests
            self.myRequests.removeAll()
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
        //Reset Request Data
        self.joinedRidePosts.removeAll()
        self.pendingRidePosts.removeAll()
        
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
                }
            })
        }
    }
    
    func deleteRidePost(ridePostId:String){
        db.collection("ridePosts").document(ridePostId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteCorrespondingRideRequests(ridePostId:String){
        db.collection("rideRequests").whereField("ridePostId", isEqualTo: ridePostId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            //delete each rideRequest Associated with the ridePost
            for document in snapshot.documents{
                if let rideRequest = RideRequest(dictionary: document.data()){
                    self.db.collection("rideRequests").document(rideRequest.rideRequestId).delete(completion: { (err) in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    })
                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension MyStatusViewController : UICollectionViewDelegateFlowLayout{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isMyRides{
            if myRidePosts.count == 0{
                collectionView.setEmptyMessage("No Rides")
            } else {
                collectionView.restore()
            }
            return myRidePosts.count
        } else {
            if joinedRidePosts.count + pendingRidePosts.count == 0{
                collectionView.setEmptyMessage("No Joined Rides")
            } else {
                collectionView.restore()
            }
            return joinedRidePosts.count + pendingRidePosts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
        cell.backgroundColor = UIColor.white
        if isMyRides{
            cell.post = myRidePosts[indexPath.section]
        } else {
            if indexPath.section >= joinedRidePosts.count{
                cell.post = pendingRidePosts[indexPath.section - joinedRidePosts.count]
            } else {
                cell.post = joinedRidePosts[indexPath.section]
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyRides{
            let detailVC = MyStatusDetailViewController()
            detailVC.ridePost = myRidePosts[indexPath.section]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
    }
    
    //Collectionview Header delegates
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerDeleteCellId, for: indexPath) as! MyStatusTrashCanHeaderCell
        if isMyRides{
            header.deleteButtonTapped = { () in
                print("Delete Button Tapped in section \(indexPath.section)")
                let ridePost = self.myRidePosts.remove(at: indexPath.section)
                guard let ridePostId = ridePost.ridePostUid else {return}
                self.deleteRidePost(ridePostId: ridePostId)
                self.deleteCorrespondingRideRequests(ridePostId: ridePostId)
                self.collectionView.reloadData()
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isMyRides{
            return CGSize(width: view.frame.width, height: 30)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}
