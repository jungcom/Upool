//
//  OfferedRidesCollectionViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/24/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import UserNotifications

private let offeredRidesCellId = "Cell"
let headerCellId = "Header"

class OfferedRidesCollectionViewController: UICollectionViewController, NVActivityIndicatorViewable {
    
    let db = Firestore.firestore()
    
    var refresher : UIRefreshControl!
    
    var allRidePosts = [RidePost]()
    var sortedRidePosts = [[RidePost]]()
    
    let addRideButton : UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.white
        button.backgroundColor = Colors.maroon
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "PlusSign"), for: .normal)
        button.imageView?.contentMode = .center
        button.contentMode = .center
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAdd(){
        let createRideVC = CreateRideViewController()
        navigationController?.pushViewController(createRideVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        // Register cell classes
        self.collectionView!.register(OfferedRidesCollectionViewCell.self, forCellWithReuseIdentifier: offeredRidesCellId)
        self.collectionView.register(OfferedRidesSectionHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.alwaysBounceVertical = true
        
        addRefresher()
        setupNavBar()
        setupFloatingButton()
        retrieveRidePosts()
    }
    
    @objc func retrieveRidePosts(){
        
        //Retrieve Data
        let docRef = db.collection(FirebaseDatabaseKeys.ridePostsKey)
        docRef.whereField("departureDate", isGreaterThan: Date().timeIntervalSinceReferenceDate).order(by: "departureDate", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                self.endRefresher()
                print("Error getting documents: \(err)")
            } else {
                //Remove all Ride Posts
                self.allRidePosts.removeAll()
                
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.allRidePosts.append(post)
                    }
                }
                self.createRidePostDictionary()
                self.collectionView.reloadData()
                self.endRefresher()
            }
        }
    }
    
    func createRidePostDictionary(){
        let groupDic = Dictionary(grouping: allRidePosts) { (ridePost) -> DateComponents in
            let date = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: (ridePost.departureDate)!)
            return date
        }
        // Sort the keys
        let sortedKeys = groupDic.keys.sorted { (date1, date2) -> Bool in
            if date1.year! != date2.year!{
                return date1.year! < date2.year!
            } else if date1.month! != date2.month!{
                return date1.month! < date2.month!
            } else {
                return date1.day! < date2.day!
            }
        }
        
        //Remove all groupedChatMessages and create a new one
        sortedRidePosts.removeAll()
        sortedKeys.forEach { (key) in
            let values = groupDic[key]
            sortedRidePosts.append(values ?? [])
        }
    }
    
    func addRefresher(){
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.gray
        self.refresher.addTarget(self, action: #selector(retrieveRidePosts), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    func endRefresher(){
        self.refresher.endRefreshing()
    }
}

    // MARK: UICollectionViewDataSource
extension OfferedRidesCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if sortedRidePosts.count == 0 {
            collectionView.setEmptyMessage("No available Rides")
            return 0
        } else {
            collectionView.restore()
            return sortedRidePosts.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedRidePosts[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.post = sortedRidePosts[indexPath.section][indexPath.row]
        
        //Disable the ridePosts that are full
        let post = cell.post
        if let current = post?.currentPassengers, let max = post?.maxPassengers{
            if current >= max {
                cell.isUserInteractionEnabled = false
                cell.alpha = 0.5
            } else {
                cell.isUserInteractionEnabled = true
                cell.alpha = 1.0
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rideDetailsVC = RideDetailViewController()
        rideDetailsVC.ridePost = sortedRidePosts[indexPath.section][indexPath.row]
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        navigationController?.pushViewController(rideDetailsVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    //Collectionview Header delegates
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! OfferedRidesSectionHeaderCollectionViewCell
        if let post = sortedRidePosts[indexPath.section].first, let date = post.departureDate {
            let dateComponent = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: date)
            header.date = dateComponent
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

}
