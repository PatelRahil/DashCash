//
//  UserData.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit

class UserData {
    var name:String
    var balance:Double
    var elo:Int
    var email:String
    var guid:String?
    var profilePic:UIImage
    
    init(data: [String:String]) {
        // Init name
        if let _name = data["name"] {
            name = _name
        } else {
            print("No name data.")
            name = ""
        }
        
        // Init balance
        if let _balanceStr = data["balance"] {
            if let _balance = Double(_balanceStr) {
                balance = _balance
            } else {
                print("Invalid balance data (not a double).")
                balance = 0
            }
        } else {
            print("No balance data.")
            balance = 0
        }
        
        // Init elo
        if let _eloString = data["elo"] {
            if let _elo = Int(_eloString) {
                elo = _elo
            } else {
                print("Invalid elo data (not an Int)")
                elo = 0
            }
        } else {
            print("No elo data.")
            elo = 0
        }
        
        // Init email
        if let _email = data["email"] {
            email = _email
        } else {
            print("No email data.")
            email = ""
        }
        
        // Init guid
        if let _guid = data["current group ID"], _guid != "" {
            guid = _guid
        }
        
        // Init profile picture
        if let _profilePicLink = data["picture"] {
            if let _profilePicURL = URL(string: _profilePicLink) {
                if let _profilePicData = try? Data(contentsOf: _profilePicURL) {
                    if let _profilePic = UIImage(data: _profilePicData) {
                        profilePic = _profilePic
                    } else {
                        print("Invalid profile picture data.")
                        profilePic = UIImage(named: "DefaultProfileImg")!
                    }
                } else {
                    print("User has not set profile pic yet")
                    profilePic = UIImage(named: "DefaultProfileImg")!
                }
            } else {
                print("Profile picture link is not a URL.")
                profilePic = UIImage(named: "DefaultProfileImg")!
            }
        } else {
            print("No profile picture data.")
            profilePic = UIImage(named: "DefaultProfileImg")!
        }
    }
    
    // Init for testing
    init (_name:String, _balance:Double, _elo:Int, _email: String, _guid: String) {
        name = _name
        balance = _balance
        elo = _elo
        email = _email
        guid = _guid
        profilePic = UIImage(named: "DefaultProfileImg")!
    }
    
    func upload() {
        // send user data to database
        
        /*
        if let uid = UserData.uid {
            let ref = FIRDatabase.database().reference(withPath: "/Users/\(uid)")
            if let name = UserData.name {
                let dic = ["name": name, "address": UserData.address]
                ref.setValue(dic)
            }
        }
         */
    }
    
    func update(with data: [String:String]) {
        // retrieve data from database and update the local user data
        
        /*
        if let info = snapshot.value as? [String:String] {
            UserData.name = info["name"]
            UserData.address = info["address"] ?? ""
        } else {
            print("Something went wrong with the snapshot")
        }
        */
    }
}
