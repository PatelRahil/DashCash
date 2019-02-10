//
//  JoinGroupVC.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit

class JoinGroupVC: UICollectionViewController {
    var userData: UserData?
    
    let itemsPerRow = 1
    let sectionInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    var potentialGroups:[GroupData] = [
        GroupData(_uid: "a", _members: [], _buyIn: 1, _level: 1, _startDate: 10000, _endDate: 15000),
        GroupData(_uid: "b", _members: [], _buyIn: 2, _level: 2, _startDate: 20000, _endDate: 25000),
        GroupData(_uid: "c", _members: [], _buyIn: 3, _level: 3, _startDate: 30000, _endDate: 35000),
        GroupData(_uid: "d", _members: [], _buyIn: 4, _level: 4, _startDate: 40000, _endDate: 45000),
        GroupData(_uid: "e", _members: [], _buyIn: 5, _level: 5, _startDate: 50000, _endDate: 55000),
        GroupData(_uid: "f", _members: [], _buyIn: 6, _level: 6, _startDate: 60000, _endDate: 65000)
                                        ]
    override func viewDidLoad() {

        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        collectionView.backgroundColor = Colors.black
    }
}

// MARK: UICollectionViewDelegate methods
extension JoinGroupVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem / 2)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: UICollectionViewDataSource methods
extension JoinGroupVC  {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return potentialGroups.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: cellForItemAt) as? PotentialGroupCell {
            cell.backgroundColor = Colors.orange
            cell.layer.cornerRadius = 8
            let group = potentialGroups[cellForItemAt.section]
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            
            if let formattedBalance = currencyFormatter.string(from: NSNumber(value: group.buyIn)) {
                cell.buyInLbl.text = formattedBalance
            } else {
                cell.buyInLbl.text = String.init(format: "$%.02f", group.buyIn)
            }
 
            cell.levelLbl.text = "Level \(group.level)"
            cell.sizeLbl.text = "\(group.members.count) / 10"
            
            return cell
        }
        return UICollectionViewCell()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath) as? PotentialGroupCell {
            let group = potentialGroups[indexPath.section]
            var buyInStr = ""
            var balanceStr = ""
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            if let formattedBalance = currencyFormatter.string(from: NSNumber(value: group.buyIn)) {
                buyInStr = formattedBalance
            } else {
                buyInStr = String.init(format: "$%.02f", group.buyIn)
            }
            if let formattedBalance = currencyFormatter.string(from: NSNumber(value: userData!.balance)) {
                balanceStr = formattedBalance
            } else {
                balanceStr = String.init(format: "$%.02f", group.buyIn)
            }
            let confirmAlertController = UIAlertController(title: "Verify", message: "Are you sure you want to join this group? The buy in is \(buyInStr) and you have \(balanceStr)", preferredStyle: .actionSheet)
            let denyAlertController = UIAlertController(title: "Insufficient funds", message: "Sorry, you do not have a high enough balance to join this group.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                if (group.buyIn > self.userData!.balance) {
                    self.present(denyAlertController, animated: true, completion: nil)
                } else {
                    let dbURL = URL(string: "http://157.230.170.230:3000/users/join=token?\(Tokens.userAuthToken)")
                    var dbRequest = URLRequest(url: dbURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
                    dbRequest.httpMethod = "POST"
                    dbRequest.httpBody = "user:\(self.userData!.userName)&groupID:\(group.uid)".data(using: .utf8)
                    let task = URLSession.shared.dataTask(with: dbRequest, completionHandler: { (data, response, error) in
                        // Set the user data to the retrieved data.
                        guard let data = data else {
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            let data = json as! [String:Any]
                            Tokens.userAuthToken = data["token"] as! String
                            self.userData = UserData(data: data)
                        } catch {
                            
                        }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "BackHomeSegue", sender: nil)
                        }
                    })
                    task.resume()
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            confirmAlertController.addAction(noAction)
            confirmAlertController.addAction(yesAction)
        }
    }
}

class PotentialGroupCell: UICollectionViewCell {
    @IBOutlet weak var buyInLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let offset: CGFloat = 15
        var origin = CGPoint(x: offset, y: offset)
        let size = CGSize(width: frame.width - (offset * 2), height: 30)
        buyInLbl.frame = CGRect(origin: origin, size: size)
        buyInLbl.textAlignment = .left
        
        origin = CGPoint(x: offset, y: (frame.width - size.height) / 2)
        levelLbl.frame = CGRect(origin: origin, size: size)
        levelLbl.textAlignment = .center
        
        origin = CGPoint(x: offset, y: frame.size.height - size.height - offset)
        sizeLbl.frame = CGRect(origin: origin, size: size)
        sizeLbl.textAlignment = .right
    }
}
