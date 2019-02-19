//
//  MyStatusDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/18/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

private let acceptedPassengerCellId = "acceptedPassengerCellId"
private let pendingPassengerCellId = "pendingPassengerCellId"
private let pendingPassengerHeaderCellId = "pendingPassengerHeaderCellId"

class MyStatusDetailViewController: UIViewController{

    let db = Firestore.firestore()
    
    var ridePost : RidePost?
    var myPassengerRequests = [RideRequest]()
    
    //Mark: UI Variables
    let topPassengerDetailView : UIView = {
        let view = UIView()
        return view
    }()
    
    let passengerStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "Passenger Status"
        label.font = UIFont(name: Fonts.helvetica, size: 16)
        label.textColor = Colors.maroon
        label.textAlignment = .center
        return label
    }()
    
    let lineSpacing : CGFloat = 15.0
    lazy var acceptedPassengersCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = lineSpacing
        let collection = UICollectionView(frame : CGRect.zero ,collectionViewLayout: layout)
        collection.register(AcceptedPassengerCollectionViewCell.self, forCellWithReuseIdentifier: acceptedPassengerCellId)
        collection.register(PendingPassengerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: pendingPassengerHeaderCellId)
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    lazy var pendingPassengersCollectionView : UICollectionView = {
        let collection = UICollectionView(frame : CGRect.zero ,collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(PendingPassengerCollectionViewCell.self, forCellWithReuseIdentifier: pendingPassengerCellId)
        collection.register(PendingPassengerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: pendingPassengerHeaderCellId)
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setupNavBar()
        setupTopPassengerDetailView()
        setupAcceptedPassengerCollectionView()
        setupPendingPassengerCollectionView()
        retrieveMyPassengers()
    }

    func retrieveMyPassengers(){
        guard let ridePost = ridePost else {return}
        db.collection("rideRequests").whereField("ridePostId", isEqualTo: ridePost.ridePostUid!).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    print("My Passenger Requests : \(document.documentID) => \(document.data())")
                    if let request = RideRequest(dictionary: document.data()){
                        self.myPassengerRequests.append(request)
                    }
                }
                self.pendingPassengersCollectionView.reloadData()
            }
        })
    }
}

extension MyStatusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == acceptedPassengersCollectionView{
            return 4
        } else {
            return myPassengerRequests.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == acceptedPassengersCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: acceptedPassengerCellId, for: indexPath) as! AcceptedPassengerCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pendingPassengerCellId, for: indexPath) as! PendingPassengerCollectionViewCell
            cell.request = myPassengerRequests[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == acceptedPassengersCollectionView{
            let totalCellWidth = collectionView.frame.width * 0.20 * 4
            let totalSpacingWidth =  CGFloat(lineSpacing * (4 - 1))
            let leftInset = (collectionView.frame.width - (totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == acceptedPassengersCollectionView{
            return CGSize(width: acceptedPassengersCollectionView.frame.width * 0.20, height: acceptedPassengersCollectionView.frame.height)
        } else {
            return CGSize(width: pendingPassengersCollectionView.frame.width * 0.9, height: 90)
        }
    }
    
    //Collectionview Header delegates
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: pendingPassengerHeaderCellId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == pendingPassengersCollectionView{
            return CGSize(width: view.frame.width, height: 70)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

}
