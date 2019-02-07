//
//  Message.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import Foundation

@objcMembers
class Message : NSObject ,Encodable,Decodable{
    
    var fromId: String!
    var toId: String!
    var text: String!
    var timeStamp : Date!
}
