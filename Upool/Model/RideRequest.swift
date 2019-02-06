//
//  RideRequest.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import Foundation

@objcMembers
class RideRequest:NSObject ,Encodable,Decodable{
    var fromId: String!
    var toDriverId: String!
    var requestStatus: Int!
    var timeStamp : Date!
    var ridePostId : String!
    var fromIdFirstName : String!
    
//    init(email:String, fn:String, ln:String, uid: String) {
//        self.email = email
//        self.firstName = fn
//        self.lastName = ln
//        self.uid = uid
//    }
    enum Status : Int {
        case pending = 0
        case confirmed = 1
        case notAccepted = -1
    }
}
