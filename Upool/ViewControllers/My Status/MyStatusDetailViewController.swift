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

class MyStatusDetailViewController: UIViewController{

    let db = Firestore.firestore()
    lazy var pendingPassengersCollectionView : UICollectionView = {
        let collection = UICollectionView(frame : CGRect.zero ,collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    var ridePost : RidePost?
    var myPassengerRequests = [RideRequest]()
    
    //Mark: UI Variables
    let topPassengerDetailView = UIView()
    
    let passengerStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "Passenger Status"
        label.font = UIFont(name: Fonts.helvetica, size: 18)
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
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.backgroundColor = UIColor.white
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
    }
    
    func setupPendingPassengerCollectionView(){
        //register Cells
        //collectionView.register(, forCellWithReuseIdentifier: )
        
        pendingPassengersCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == acceptedPassengersCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: acceptedPassengerCellId, for: indexPath) as! AcceptedPassengerCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
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
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: acceptedPassengersCollectionView.frame.width * 0.20, height: acceptedPassengersCollectionView.frame.height)
    }
}
