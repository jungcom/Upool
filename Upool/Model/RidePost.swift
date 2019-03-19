//
//  RidePost.swift
//  Upool
//
//  Created by Anthony Lee on 2/1/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit

@objcMembers
class RidePost : NSObject, Encodable,Decodable, NSCopying{
    
    //Ride Fields NEEDED when posted
    var departureDate : Date? = nil
    var departureTime : Date? = nil
    var departureCity : String? = nil
    var arrivalCity : String? = nil
    var price : Int? = nil
    var maxPassengers : Int? = nil
    var pickUpDetails : String? = nil
    var cashPay : Bool? = nil
    var venmoPay : Bool? = nil
    
    var driverUid : String? = nil
    
    //Ride
    var currentPassengers : Int? = 0
    var ridePostUid : String? = nil
    
    //see if ride is full
    var rideIsFull : Bool{
        if let max = maxPassengers, let current = currentPassengers{
            if max == current{
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    //Flag to see if all ride fields are complete
    var allFieldsFull : Bool{
        if let _ = departureDate, let _ = departureTime, let _ = departureCity, let _ = arrivalCity, let _ = price, let _ = maxPassengers, let _ = pickUpDetails{
            return true
        } else {
            return false
        }
    }
    
    //Make a deep copy
    func copy(with zone: NSZone? = nil) -> Any
    {
        let address = RidePost(dictionary: self.dictionary) as Any
        return address
    }
    
    func dateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let departureDate = departureDate{
            return formatter.string(from: departureDate)
        } else {
            return ""
        }
    }
    
    func timeString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        if let departureTime = departureTime{
            return formatter.string(from: departureTime)
        } else {
            return ""
        }
    }
}
