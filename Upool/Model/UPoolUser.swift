//
//  User.swift
//  Upool
//
//  Created by Anthony Lee on 2/2/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import Foundation

@objcMembers
class UPoolUser:NSObject ,Encodable,Decodable{
    var firstName: String!
    var lastName: String!
    var email: String!
    var uid : String!
    var profileImageUrl : String?
    
    init(email:String, fn:String, ln:String, uid: String) {
        self.email = email
        self.firstName = fn
        self.lastName = ln
        self.uid = uid
    }
}
