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
    var myPendingPassengerRequests = [RideRequest]()
    var myAcceptedPassengerRequests = [RideRequest]()
    
    //Mark: UI Variables
    let topPassengerDetailView : UIView = {
        let view = UIView()
        return view
    }()
    
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
        retrieveMyPassengerRequests()
    }

    func retrieveMyPassengerRequests(){
        myAcceptedPassengerRequests.removeAll()
        myPendingPassengerRequests.removeAll()
        
        guard let ridePost = ridePost else {return}
        db.collection("rideRequests").whereField("ridePostId", isEqualTo: ridePost.ridePostUid!).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    print("My Passenger Requests : \(document.documentID) => \(document.data())")
                    if let request = RideRequest(dictionary: document.data()){
                        if request.requestStatus == Status.confirmed.rawValue{
                            self.myAcceptedPassengerRequests.append(request)
                        } else if request.requestStatus == Status.pending.rawValue{
                            self.myPendingPassengerRequests.append(request)
                        } else if request.requestStatus == Status.notAccepted.rawValue{
                            //Code For Not Accepted Passengers
                        }
                    }
                }
                self.pendingPassengersCollectionView.reloadData()
                self.acceptedPassengersCollectionView.reloadData()
            }
        })
    }
}

extension MyStatusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == acceptedPassengersCollectionView{
            return ridePost?.maxPassengers ?? 4
        } else {
            if myPendingPassengerRequests.count == 0{
                collectionView.setEmptyMessage("No Requests")
            } else {
                collectionView.restore()
            }
            return myPendingPassengerRequests.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == acceptedPassengersCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: acceptedPassengerCellId, for: indexPath) as! AcceptedPassengerCollectionViewCell
            if indexPath.row < myAcceptedPassengerRequests.count {
                cell.rideRequest = myAcceptedPassengerRequests[indexPath.row]
            } else {
                //set cell to empty
                cell.empty = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pendingPassengerCellId, for: indexPath) as! PendingPassengerCollectionViewCell
            cell.rideRequest = myPendingPassengerRequests[indexPath.row]
            cell.ridePost = self.ridePost
            //When user accepts a ride request
            cell.acceptButtonTapped = { () in
                let acceptedRequest = self.myPendingPassengerRequests.remove(at: indexPath.row)
                self.myAcceptedPassengerRequests.append(acceptedRequest)
                self.acceptedPassengersCollectionView.reloadData()
                self.pendingPassengersCollectionView.reloadData()
            }
            //When user declines a ride Request
            cell.declineButtonTapped = { () in
                self.myPendingPassengerRequests.remove(at: indexPath.row)
                self.pendingPassengersCollectionView.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //Center the AccepetedPassengerCells
        if collectionView == acceptedPassengersCollectionView{
            let cellNumber = CGFloat(ridePost?.maxPassengers ?? 4)
            let totalCellWidth = collectionView.frame.width * 0.20 * cellNumber
            let totalSpacingWidth =  CGFloat(lineSpacing * (cellNumber - 1))
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
            if myPendingPassengerRequests.count == 0{
                return CGSize(width: 0, height: 0)
            } else {
                return CGSize(width: view.frame.width, height: 70)
            }
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

}
