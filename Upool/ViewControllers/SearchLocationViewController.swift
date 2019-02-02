//
//  SearchLocationViewController.swift
//  Upool
//
//  Created by Anthony Lee on 1/30/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationViewController: UIViewController {
    
    var delegate : ModalPassDataDelegate? = nil
    var forDeparture : Bool? = true
    
    lazy var resultsViewController: GMSAutocompleteResultsViewController = {
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        return resultsViewController
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        return searchController
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let topView : UIView = {
        let view = UIView()
        return view
    }()
    
    var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupTopViewAndSearch()
        
        navigationController?.navigationBar.isTranslucent = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
    }
    
    func setupTopViewAndSearch(){
        
        searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = true
        
        topView.addSubview(searchBar)
        view.addSubview(topView)
        //view.addSubview(cancelButton)
        
        //topView Constraints
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //SearchBarConstraints
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //searchBar.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true

        //buttonConstraints
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        cancelButton.leadingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
//        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        cancelButton.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 1).isActive = true
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
//        definesPresentationContext = true
        modalPresentationStyle = .currentContext
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
}

// Handle the user's selection.
extension SearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController.isActive = false
        
        // Do something with the selected place.
//        let gms = component?[0]
//        let gms2 = component?[1]
//
//        print("Place addressComponents: \(gms?.type)")
//        print("Place address: \(gms2?.name)")
        if forDeparture!{
            delegate?.sendDepartureData(departureCity: "\(place.formattedAddress!)")
        } else {
            delegate?.sendArrivalData(arrivalCity: "\(place.formattedAddress!)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
