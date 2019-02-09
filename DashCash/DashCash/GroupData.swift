//
//  GroupData.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit

class GroupData {
    var uid: String
    var members: [String]
    var pool: Double
    var level: Int
    var size: Int
    
    init(_uid: String, _members: [String], _pool: Double, _level: Int, _size: Int) {
        uid = _uid
        members = _members
        pool = _pool
        level = _level
        size = _size
    }
    
    init(data: [String:Any]) {
        if let _uid = data["uID"] {
            uid = _uid as! String
        } else {
            print("No uID data.")
            uid = ""
        }
        if let _members = data["members"] {
            members = _members as! [String]
        } else {
            print("No members data.")
            members = []
        }
        if let _pool = data["pool"] {
            pool = _pool as! Double
        } else {
            print("No pool data.")
            pool = 0
        }
        if let _level = data["level"] {
            level = _level as! Int
        } else {
            print("No level data.")
            level = 0
        }
        if let _size = data["size"] {
            size = _size as! Int
        } else {
            print("No size data.")
            size = 0
        }
    }
}
