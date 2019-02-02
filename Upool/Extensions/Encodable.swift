//
//  Encodable.swift
//  Upool
//
//  Created by Anthony Lee on 2/1/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import Foundation

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
