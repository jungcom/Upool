//
//  CreateRideProtocolsForPassingData.swift
//  Upool
//
//  Created by Anthony Lee on 1/31/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

protocol ModalPassDataDelegate: class {
    func sendDepartureData(departureCity: String)
    func sendArrivalData(arrivalCity: String)
}

extension CreateRideViewController:  ModalPassDataDelegate {
    
    func sendDepartureData(departureCity: String) {
        self.departureCity = departureCity
        self.fromLabel.text = departureCity
        self.fromLabel.textColor = Colors.maroon
    }
    
    func sendArrivalData(arrivalCity: String) {
        self.arrivalCity = arrivalCity
        self.toLabel.text = arrivalCity
        self.toLabel.textColor = Colors.maroon
    }
}
