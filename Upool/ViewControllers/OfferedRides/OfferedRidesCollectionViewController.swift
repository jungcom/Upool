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
private let headerCellId = "Header"

class OfferedRidesCollectionViewController: UICollectionViewController, NVActivityIndicatorViewable {
    
    let db = Firestore.firestore()
    
    var refresher : UIRefreshControl!
    
    var todayRidePosts = [RidePost]()
    var tomorrowRidePosts = [RidePost]()
    var laterRidePosts = [RidePost]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear")
        retrieveRidePosts()
    }
    
    @objc func retrieveRidePosts(){
//        //Remove all Ride Posts
//        todayRidePosts.removeAll()
//        tomorrowRidePosts.removeAll()
//        laterRidePosts.removeAll()
        
        //Retrieve Data
        let docRef = db.collection("ridePosts")
        docRef.whereField("departureDate", isGreaterThan: Date().timeIntervalSinceReferenceDate).order(by: "departureDate", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                self.endRefresher()
                print("Error getting documents: \(err)")
            } else {
                //Remove all Ride Posts
                self.todayRidePosts.removeAll()
                self.tomorrowRidePosts.removeAll()
                self.laterRidePosts.removeAll()
                
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.addToCorrectSection(post)
                    }
                }
                self.collectionView.reloadData()
                self.endRefresher()
            }
        }
    }
    
    func addToCorrectSection(_ post : RidePost){
        if let date = post.departureDate{
            if Calendar.current.isDateInToday(date){
                todayRidePosts.append(post)
            } else if Calendar.current.isDateInTomorrow(date){
                tomorrowRidePosts.append(post)
            } else {
                laterRidePosts.append(post)
            }
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
        if todayRidePosts.count == 0 && tomorrowRidePosts.count == 0 && laterRidePosts.count == 0{
            collectionView.setEmptyMessage("No available Rides")
            return 0
        } else {
            collectionView.restore()
        }
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return todayRidePosts.count
        } else if section == 1{
            return tomorrowRidePosts.count
        } else {
            return laterRidePosts.count
        }

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
        cell.backgroundColor = UIColor.white
        if indexPath.section == 0{
            cell.post = todayRidePosts[indexPath.row]
        } else if indexPath.section == 1{
            cell.post = tomorrowRidePosts[indexPath.row]
        } else {
            print("indexPath : \(indexPath.row)")
            cell.post = laterRidePosts[indexPath.row]
        }
        
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
        if indexPath.section == 0{
            rideDetailsVC.ridePost = todayRidePosts[indexPath.row]
        } else if indexPath.section == 1{
            rideDetailsVC.ridePost = tomorrowRidePosts[indexPath.row]
        } else {
            rideDetailsVC.ridePost = laterRidePosts[indexPath.row]
        }
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
        if indexPath.section == 0 {
            header.titleLabel.text = headerType.today
        } else if indexPath.section == 1{
            header.titleLabel.text = headerType.tomorrow
        } else {
            header.titleLabel.text = headerType.laterRides
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if todayRidePosts.count == 0{
                return CGSize(width: 0, height: 0)
            }
        } else if section == 1{
            if tomorrowRidePosts.count == 0{
                return CGSize(width: 0, height: 0)
            }
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
        return CGSize(width: view.frame.width, height: 50)
    }

}
