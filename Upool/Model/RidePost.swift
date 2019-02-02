//
//  RidePost.swift
//  Upool
//
//  Created by Anthony Lee on 2/1/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit

@objcMembers
class RidePost : NSObject, Encodable{
    //Ride Fields
    var departureDate : Date? = nil
    var departureTime : Date? = nil
    var departureCity : String? = nil
    var arrivalCity : String? = nil
    var price : Int? = nil
    var maxPassengers : Int? = nil
    var pickUpDetails : String? = nil
    
    //Flag to see if all ride fields are complete
    var allFieldsFull : Bool{
        if let _ = departureDate, let _ = departureTime, let _ = departureCity, let _ = arrivalCity, let _ = price, let _ = maxPassengers, let _ = pickUpDetails{
            return true
        } else {
            return false
        }
    }
}
