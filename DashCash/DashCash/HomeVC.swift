//
//  HomeVC.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    var userData: UserData?
    var groupData: GroupData?
    
    override func viewDidLoad() {
        userData = UserData(_userName: "John Doe", _balance: 12.5, _elo: 0, _email: "test@email.com", _guid: "l4g4jsm46s0g4k2jfb4")
        if let _userData = userData {
            setupProfileUI(with: _userData)
            setupGroupUI(with: _userData.guid)
        } else {
            print("User data does not exit yet.")
            let tempUserData = UserData(_userName: "", _balance: 0, _elo: 0, _email: "", _guid: "")
            setupProfileUI(with: tempUserData)
            setupAbsentGroupUI()
        }
    }
    
    private func setupProfileUI(with data: UserData) {
        view.backgroundColor = Colors.black
        
        // Gap between UI elements
        let offset: CGFloat = 20
        
        // Set up profile picture.
        let profilePicView = UIImageView(image: data.profilePic)
        let yPos: CGFloat = 40
        let xPos: CGFloat = 3 * view.frame.width / 8
        let width: CGFloat = 2 * view.frame.width / 8
        let height = width
        profilePicView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        // Makes profile picture a circle.
        profilePicView.layer.cornerRadius = width / 2
        profilePicView.layer.masksToBounds = true
        
        // Set up name label.
        let nameLbl = UILabel()
        let nameLblSize = CGSize(width: view.frame.width, height: 20)
        let nameLblOrigin = CGPoint(x: 0, y: profilePicView.frame.maxY + offset)
        nameLbl.frame = CGRect(origin: nameLblOrigin, size: nameLblSize)
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont(name: nameLbl.font.fontName, size: 20)
        nameLbl.textColor = UIColor.white
        nameLbl.text = data.userName
        
        // Set up balance label.
        let balanceLbl = UILabel()
        let balanceLblOrigin = CGPoint(x: 0, y: nameLbl.frame.maxY + offset)
        let balanceLblSize = CGSize(width: view.frame.width, height: 40)
        balanceLbl.frame = CGRect(origin: balanceLblOrigin, size: balanceLblSize)
        balanceLbl.textAlignment = .center
        balanceLbl.font = UIFont(name: balanceLbl.font.fontName, size: 40)
        balanceLbl.textColor = Colors.orange
        
        // Format text for currency.
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        if let formattedBalance = currencyFormatter.string(from: NSNumber(value: data.balance)) {
            balanceLbl.text = formattedBalance
        } else {
            print("Something went wrong with formatting. Default to dollar.")
            balanceLbl.text = String.init(format: "$%.02f", data.balance)
        }
        
        // Separator for visual purposes.
        let separator = UIView()
        separator.backgroundColor = Colors.orange
        separator.frame = CGRect(x: view.frame.width / 24, y: balanceLbl.frame.maxY + offset, width: (view.frame.width - (view.frame.width / 12)), height: 1)
        
        print("Profile Pic Frame: \(profilePicView.frame)")
        print("Name Label Frame: \(nameLbl.frame)")
        print("Balance Label Frame: \(balanceLbl.frame)")
        view.addSubview(profilePicView)
        view.addSubview(nameLbl)
        view.addSubview(balanceLbl)
        view.addSubview(separator)
    }
    private func setupGroupUI(with guid: String?) {
        if let _guid = guid {
            // The user is a member of a group
            
            // A default group until the group data is loaded.
            let tempGroupData = GroupData(_uid: "", _members: [], _pool: 0, _level: 0, _size: 0)
            setupPresentGroupUI(with: tempGroupData)
            
            let dbURL = URL(string: "")
            var dbRequest = URLRequest(url: dbURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            dbRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: dbRequest, completionHandler: { (data, response, error) in
                // Set the user data to the retrieved data.
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.groupData = GroupData(data: json as! [String:String])
                } catch {
                    
                }
                self.setupPresentGroupUI(with: self.groupData!)
            })
        } else {
            setupAbsentGroupUI()
        }
    }
    private func setupPresentGroupUI(with data: GroupData) {
        
    }
    private func setupAbsentGroupUI() {
        
    }
}
