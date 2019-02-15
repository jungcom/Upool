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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(OfferedRidesCollectionViewCell.self, forCellWithReuseIdentifier: offeredRidesCellId)
        self.collectionView.register(OfferedRidesSectionHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.alwaysBounceVertical = true
        
        addRefresher()
        setupNavBar()
        retrieveRidePosts()
        
        //Test Notifications
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @objc func retrieveRidePosts(){
        //Remove all Ride Posts
        todayRidePosts.removeAll()
        tomorrowRidePosts.removeAll()
        laterRidePosts.removeAll()
        
        //Retrieve Data
        let docRef = db.collection("ridePosts")
        docRef.whereField("departureDate", isGreaterThan: Date().timeIntervalSinceReferenceDate).order(by: "departureDate", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
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
    
    @objc func createRide(){
        let createRideVC = CreateRideViewController()
        navigationController?.pushViewController(createRideVC, animated: true)
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
            cell.post = laterRidePosts[indexPath.row]
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
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
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
