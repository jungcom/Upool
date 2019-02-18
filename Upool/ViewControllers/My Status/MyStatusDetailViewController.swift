//
//  MyStatusDetailViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/18/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

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
    
    lazy var acceptedPassengersCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame : CGRect.zero ,collectionViewLayout: layout)
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.delegate = self
        collection.dataSource = self
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

extension MyStatusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = Colors.maroon
        return cell
    }
    
    
}
