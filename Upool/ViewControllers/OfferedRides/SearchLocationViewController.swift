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
    
    let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
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
        navigationItem.title = forDeparture! ? "From" : "To"
        
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
        let components = place.addressComponents
        var city : String?
        var state : String?
        if let componentsEnum = components?.enumerated(){
            for (_, gms) in componentsEnum{
                if gms.type == "administrative_area_level_1"{
                    state = self.shortStateName(gms.name)
                } else if gms.type == "locality"{
                    city = gms.name
                }
            }
        }
        var address = place.formattedAddress
        if let city = city, let state = state{
            address = "\(city), \(state)"
        }
        if forDeparture!{
            delegate?.sendDepartureData(departureCity: address ?? "")
        } else {
            delegate?.sendArrivalData(arrivalCity: address ?? "")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func shortStateName(_ state:String) -> String {
        let lowercaseNames = fullStateNames.map { $0.lowercased() }
        let dic = NSDictionary(objects: stateCodes, forKeys: lowercaseNames as [NSCopying])
        return dic.object(forKey:state.lowercased()) as? String ?? state
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        
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
