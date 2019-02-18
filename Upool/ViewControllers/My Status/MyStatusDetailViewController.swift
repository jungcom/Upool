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
    let collectionView = UICollectionView()
    
    var ridePost : RidePost?
    var myPassengerRequests = [RideRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
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
                self.collectionView.reloadData()
            }
        })
    }
}
