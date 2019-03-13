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
    //var joinedAndPendingRidePosts = [[RidePost]]()
    var joinedRidePosts = [RidePost]()
    var pendingRidePosts = [RidePost]()
    var declinedRidePosts = [RidePost]()
    
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
        self.collectionView.register(OfferedRidesSectionHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
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
        self.declinedRidePosts.removeAll()
        
        //Handle Asynchronous tasks
        let group = DispatchGroup()
        
        //Retrieve Ride Data for each request
        for request in myRequests{
            group.enter()
            db.collection("ridePosts").document(request.ridePostId).getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    group.leave()
                } else {
                    if let post = RidePost(dictionary: (snapshot?.data())!), let date = post.departureDate{
                        //If the ride is in the near future
                        if date > Date(){
                            if request.requestStatus == 0{
                                self.pendingRidePosts.append(post)
                            } else if request.requestStatus == 1{
                                self.joinedRidePosts.append(post)
                            } else if request.requestStatus == -1{
                                self.declinedRidePosts.append(post)
                            }
                        }
                    }
                    group.leave()
                }
            })
        }
        
        //When all ridePosts are retrieved for all requests
        group.notify(queue: .main) {
            self.collectionView.reloadData()
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
            return 3
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyRides{
            return 1
        } else {
            if section == 0{
                return joinedRidePosts.count
            } else if section == 1{
                return pendingRidePosts.count
            } else {
                return declinedRidePosts.count
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
        cell.backgroundColor = UIColor.white
        if isMyRides{
            cell.post = myRidePosts[indexPath.section]
        } else {
            if indexPath.section == 0{
                cell.post = joinedRidePosts[indexPath.row]
            } else if indexPath.section == 1{
                cell.post = pendingRidePosts[indexPath.row]
            } else {
                cell.post = declinedRidePosts[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyRides{
            let detailVC = MyStatusDetailViewController()
            detailVC.ridePost = myRidePosts[indexPath.section]
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("Section : \(indexPath.section)")
            let detailVC = JoinedRidesDetailViewController()
            if indexPath.section == 0{
                detailVC.ridePost = joinedRidePosts[indexPath.row]
            } else if indexPath.section == 1{
                detailVC.ridePost = pendingRidePosts[indexPath.row]
            } else {
                detailVC.ridePost = declinedRidePosts[indexPath.row]
            }
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
        if isMyRides{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerDeleteCellId, for: indexPath) as! MyStatusTrashCanHeaderCell
            header.deleteButtonTapped = { () in
                print("Delete Button Tapped in section \(indexPath.section)")
                let ridePost = self.myRidePosts.remove(at: indexPath.section)
                guard let ridePostId = ridePost.ridePostUid else {return}
                self.deleteRidePost(ridePostId: ridePostId)
                self.deleteCorrespondingRideRequests(ridePostId: ridePostId)
                self.collectionView.reloadData()
            }
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! OfferedRidesSectionHeaderCollectionViewCell
            if indexPath.section == 0{
                header.titleLabel.text = "Joined Rides"
            } else if indexPath.section == 1{
                header.titleLabel.text = "Pending Rides"
            } else {
                header.titleLabel.text = "Declined Rides"
            }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isMyRides{
            return CGSize(width: view.frame.width, height: 30)
        } else {
            if section == 0 && joinedRidePosts.count != 0 ||
               section == 1 && pendingRidePosts.count != 0 ||
                section == 2 && declinedRidePosts.count != 0 {
                return CGSize(width: view.frame.width, height: 30)
            } else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
}
