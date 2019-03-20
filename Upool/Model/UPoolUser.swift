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
    var fcmToken : String!
    var profileImageUrl : String?
    var carImageUrl : String?
    
    //Profile Information
    var gradYear : String?
    var major : String?
    var age : String?
    var gender : String?
    
    init(email:String, fn:String, ln:String, uid: String, fcmToken : String) {
        self.email = email
        self.firstName = fn
        self.lastName = ln
        self.uid = uid
        self.fcmToken = fcmToken
    }
}
