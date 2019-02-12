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
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    let topView : UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupNavBarAndSearchBar()
        
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.

    }
    
    func setupNavBarAndSearchBar(){
        navigationController?.navigationBar.barTintColor = Colors.maroon
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.tintColor = UIColor.white
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]) ).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.definesPresentationContext = true
        modalPresentationStyle = .currentContext
    }
}

// Handle the user's selection.
extension SearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate, UISearchBarDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController.isActive = true
        
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
        navigationController?.dismiss(animated: true, completion: nil)
        
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Clicked")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
}
