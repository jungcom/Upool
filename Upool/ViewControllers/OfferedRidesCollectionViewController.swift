//
//  OfferedRidesCollectionViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/24/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

private let offeredRidesCellId = "Cell"
private let headerCellId = "Header"

class OfferedRidesCollectionViewController: UICollectionViewController {
    
    let db = Firestore.firestore()
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
        
        setupNavBar()
        retrieveRidePosts()
    }
    
    func retrieveRidePosts(){
        let docRef = db.collection("ridePosts")
        
        docRef.order(by: "departureDate", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.addToCorrectSection(post)
                    }
                    self.collectionView.reloadData()
                }
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
