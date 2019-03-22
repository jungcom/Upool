//
//  RideRequest.swift
//  Upool
//
//  Created by Anthony Lee on 2/4/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import Foundation

enum Status : Int {
    case pending = 0
    case confirmed = 1
    case notAccepted = -1
}

@objcMembers
class RideRequest:NSObject ,Encodable,Decodable{
    var fromId: String!
    var toDriverId: String!
    var requestStatus: Int!
    var timeStamp : Date!
    var ridePostId : String!
    var fromIdFirstName : String!
    var rideRequestId : String!
}
