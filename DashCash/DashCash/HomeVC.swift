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
    var payouts:[Double] = []
    var isInGroup = false
    
    // UI Elements
    let profilePicView = UIImageView()
    let nameLbl = UILabel()
    let balanceLbl = UILabel()
    let separator = UIView()
    let joinGroupBtn = UIButton()
    let progressLbl = UILabel()
    let progressBar = UIProgressView()
    let startDateLbl = UILabel()
    let endDataLbl = UILabel()
    let separator2 = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupMemberCell.self, forCellReuseIdentifier: "GroupMemberCell")
        //userData = UserData(_userName: "John Doe", _balance: 12.5, _elo: 0, _email: "test@email.com", _guid: "l4g4jsm46s0g4k2jfb4", _progress: 24.5)
        if let _userData = userData {
            print("User values:")
            _userData.printValues()
            setupProfileUI(with: _userData)
            
            
            // Gets the group that the current user is in
            // if he/she is in one.
            let dbURL = URL(string: "http://157.230.170.230:3000/Users/\(_userData.userName)/getGroup")
            var dbRequest = URLRequest(url: dbURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            dbRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: dbRequest, completionHandler: { (data, response, error) in
                // Set the user data to the retrieved data.
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Not and http response.")
                    return
                }
                if httpResponse.statusCode >= 200 {
                    print("User doesn't have a group.")
                    self.setupAbsentGroupUI()
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        self.groupData = GroupData(data: json as! [String:Any])
                        self.setupPresentGroupUI(with: self.groupData!, progress: _userData.progress)
                    } catch {
                        print("There was an error parsing the json.")
                    }
                }
            })
            task.resume()
            
        } else {
            print("User data does not exit yet.")
            let tempUserData = UserData(_userName: "", _balance: 0, _elo: 0, _email: "", _guid: "", _progress: 0)
            setupProfileUI(with: tempUserData)
            setupAbsentGroupUI()
        }
    }
    
    private func setupProfileUI(with data: UserData) {
        view.backgroundColor = Colors.black
        
        // Gap between UI elements
        let offset: CGFloat = 20
        
        // Set up profile picture.
        profilePicView.image = data.profilePic
        let yPos: CGFloat = 40
        let xPos: CGFloat = 3 * view.frame.width / 8
        let width: CGFloat = 2 * view.frame.width / 8
        let height = width
        profilePicView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        // Makes profile picture a circle.
        profilePicView.layer.cornerRadius = width / 2
        profilePicView.layer.masksToBounds = true
        
        // Set up name label.
        let nameLblSize = CGSize(width: view.frame.width, height: 20)
        let nameLblOrigin = CGPoint(x: 0, y: profilePicView.frame.maxY + offset)
        nameLbl.frame = CGRect(origin: nameLblOrigin, size: nameLblSize)
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont(name: nameLbl.font.fontName, size: 20)
        nameLbl.textColor = UIColor.white
        nameLbl.text = data.userName
        
        // Set up balance label.
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
        separator.backgroundColor = Colors.orange
        separator.frame = CGRect(x: view.frame.width / 24, y: balanceLbl.frame.maxY + offset, width: (view.frame.width - (view.frame.width / 12)), height: 1)

        view.addSubview(profilePicView)
        view.addSubview(nameLbl)
        view.addSubview(balanceLbl)
        view.addSubview(separator)
    }
    
    private func setupPresentGroupUI(with gData: GroupData, progress: Int) {
        let offset: CGFloat = 20
        var origin = CGPoint(x: 0, y: separator.frame.maxY + offset)
        var size = CGSize(width: view.frame.width, height: 40)
        progressLbl.frame = CGRect(origin: origin, size: size)
        progressLbl.textAlignment = .center
        progressLbl.textColor = Colors.orange
        progressLbl.font = UIFont(name: progressLbl.font.fontName, size: 40)
        progressLbl.text = "\(progress) minutes"
        
        origin = CGPoint(x: view.frame.width / 4, y: progressLbl.frame.maxY + offset)
        size = CGSize(width: view.frame.width / 2, height: 30)
        progressBar.frame = CGRect(origin: origin, size: size)
        let timeSpent = Int(Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate) - (gData.startDate)
        let totalTime = gData.endDate - gData.startDate
        progressBar.setProgress(Float(timeSpent)/Float(totalTime), animated: false)
        print(timeSpent)
        print(totalTime)
        progressBar.progressTintColor = Colors.orange
        progressBar.layer.borderColor = UIColor.white.cgColor
        let transform = CGAffineTransform(scaleX: 1, y: 3)
        progressBar.transform = transform
        
        
        
        origin = CGPoint(x: view.frame.width / 24, y: progressBar.frame.maxY + offset)
        size = CGSize(width: (view.frame.width - (view.frame.width / 12)), height: 1)
        separator2.frame = CGRect(origin: origin, size: size)
        separator2.backgroundColor = Colors.orange
        
        origin = CGPoint(x: 0, y: separator2.frame.maxY)
        size = CGSize(width: view.frame.width, height: view.frame.width - separator2.frame.maxY)
        tableView.backgroundColor = Colors.black
        tableView.separatorColor = Colors.orange
        
        calculatePayouts(for: gData)
        
        view.addSubview(progressLbl)
        view.addSubview(progressBar)
        view.addSubview(separator2)
        view.addSubview(tableView)
        
        tableView.reloadData()
        print("TABLEVIEW DATA:\n\n")
        print(tableView.frame)
        print(tableView.numberOfRows(inSection: 0))
    }
    private func setupAbsentGroupUI() {
        let offset: CGFloat = 20
        let origin = CGPoint(x: 0, y: separator.frame.maxY + offset)
        let size = CGSize(width: view.frame.width, height: view.frame.height - origin.y)
        joinGroupBtn.frame = CGRect(origin: origin, size: size)
        joinGroupBtn.setTitle("Tap here to look for a group!", for: .normal)
        joinGroupBtn.addTarget(self, action: #selector(findGroupTapped(_:)), for: .touchUpInside)
        
        view.addSubview(joinGroupBtn)
    }
    
    private func calculatePayouts(for group: GroupData) {
        let size = group.members.count
        let n = Double(size)
        let bigConst: Double = 1000
        let smallConst: Double = 20
        let totalScore: Double = bigConst * n - ((1 + n) * n * smallConst) / 2
        
        for i in 0..<size {
            let score: Double = bigConst - smallConst * Double(i)
            let payoutCoef: Double = n * (score / totalScore)
            let payout: Double = payoutCoef * group.buyIn
            payouts[i] = payout
        }
    }
    
    @objc func findGroupTapped(_ sender: Any) {
        print("Tapped!")
        performSegue(withIdentifier: "JoinGroupSegue", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? JoinGroupVC {
            dest.userData = userData!
        }
    }
}

extension HomeVC: UITableViewDelegate {
    
}
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData?.members.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell") as! GroupMemberCell
        if let members = groupData?.members {
            let member = members[indexPath.row]
            let memberData = UserData(data: member)
            cell.usernameLbl.text = memberData.userName
            cell.userImg = UIImageView(image: memberData.profilePic)
            cell.progressLbl.text = "\(memberData.progress) min"
            let payout = payouts[indexPath.row]
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            if let formattedPayout = currencyFormatter.string(from: NSNumber(value: payout)) {
                cell.payoutLbl.text = formattedPayout
            } else {
                cell.payoutLbl.text = String.init(format: "$%.02f", payout)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

class GroupMemberCell: UITableViewCell {
    var userImg = UIImageView()
    var usernameLbl = UILabel()
    var progressLbl = UILabel()
    let divider = UIView()
    var payoutLbl = UILabel()
    
    override func awakeFromNib() {
        self.backgroundColor = Colors.black
        var origin = CGPoint(x: 0, y: 5)
        var size = CGSize(width: 60, height: 60)
        userImg.frame = CGRect(origin: origin, size: size)
        userImg.layer.cornerRadius = userImg.frame.width / 2
        userImg.layer.masksToBounds = true
        origin = CGPoint(x: userImg.frame.maxX + 10, y: userImg.frame.minY)
        size = CGSize(width: 100, height: self.frame.height)
        usernameLbl.frame = CGRect(origin: origin, size: size)
        size = CGSize(width: 40, height: self.frame.height)
        origin = CGPoint(x: self.frame.width - size.width - 10, y: 0)
        payoutLbl.frame = CGRect(origin: origin, size: size)
        size = CGSize(width: 1, height: self.frame.height - 10)
        origin = CGPoint(x: payoutLbl.frame.minY - 5, y: 5)
        divider.frame = CGRect(origin: origin, size: size)
        divider.backgroundColor = Colors.orange
        size = CGSize(width: 60, height: self.frame.height)
        origin = CGPoint(x: divider.frame.minX - 5, y: 0)
        progressLbl.frame = CGRect(origin: origin, size: size)
    }
    
}
