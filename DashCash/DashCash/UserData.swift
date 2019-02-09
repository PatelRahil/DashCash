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
    var userName:String
    var balance:Double
    var elo:Int
    var email:String
    var profilePic:UIImage
    var progress:Int
    
    init(data: [String:Any]) {
        // Init userName
        if let _userName = data["userName"] as? String {
            userName = _userName
        } else {
            print("No userName data.")
            userName = ""
        }
        
        // Init balance
        if let _balance = data["balance"] as? Double {
            balance = _balance
        } else {
            print("No balance data.")
            balance = 0
        }
        
        // Init elo
        if let _elo = data["elo"] as? Int {
            elo = _elo
        } else {
            print("No elo data.")
            elo = 0
        }
        
        // Init email
        if let _email = data["email"] as? String {
            email = _email
        } else {
            print("No email data.")
            email = ""
        }
        
        // Init profile picture
        if let _profilePicLink = data["picture"] as? String {
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
        
        // Init progress
        if let _progress = data["progress"] as? Int {
            progress = _progress
        } else {
            print("No progress data.")
            progress = 0
        }
    }
    
    // Init for custom user data.
    init (_userName:String, _balance:Double, _elo:Int, _email: String, _guid: String, _progress: Int) {
        userName = _userName
        balance = _balance
        elo = _elo
        email = _email
        profilePic = UIImage(named: "DefaultProfileImg")!
        progress = _progress
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
    
    // For testing
    func printValues() {
        print("Username: \(userName)")
        print("Balance: \(balance)")
        print("ELO: \(elo)")
        print("Email: \(email)")
        print("Progress: \(progress)")
    }
}
