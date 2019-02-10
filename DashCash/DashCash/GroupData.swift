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
    var buyIn: Double
    var level: Int
    var startDate: Int
    var endDate: Int
    
    init(_uid: String, _members: [String], _buyIn: Double, _level: Int, _startDate: Int, _endDate: Int) {
        uid = _uid
        members = _members
        buyIn = _buyIn
        level = _level
        startDate = _startDate
        endDate = _endDate
    }
    
    init(data: [String:Any]) {
        print("\n\n\nDATA: ")
        print(data)
        if let _uid = data["_id"] as? String {
            uid = _uid
        } else {
            print("No uID data.")
            uid = ""
        }
        if let _members = data["members"] as? [String] {
            members = _members
        } else {
            print("No members data.")
            members = []
        }
        if let _buyIn = data["buyIn"] as? Double {
            buyIn = _buyIn
        } else {
            print("No buyIn data.")
            buyIn = 0
        }
        if let _level = data["level"] as? Int {
            level = _level
        } else {
            print("No level data.")
            level = 0
        }
        if let _startDate = data["start date"] as? Int {
            startDate = _startDate
        } else {
            print("No startDate data.")
            startDate = 0
        }
        if let _endDate = data["end date"] as? Int {
            endDate = _endDate
        } else {
            print("No endDate data")
            endDate = 0
        }
    }
}
