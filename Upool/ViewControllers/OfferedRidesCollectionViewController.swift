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
    var ridePosts = [RidePost]()
    
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
        
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let post = RidePost(dictionary: document.data()){
                        self.ridePosts.append(post)
                    }
                    self.collectionView.reloadData()
                }
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
        return ridePosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offeredRidesCellId, for: indexPath) as! OfferedRidesCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.post = ridePosts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rideDetailsVC = RideDetailViewController()
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
        return header

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

}
