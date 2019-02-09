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
    
    var potentialGroups:[GroupData] = []
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: UICollectionViewDataSource methods
extension JoinGroupVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return potentialGroups.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: cellForItemAt)
        cell.backgroundColor = Colors.orange
        cell.layer.cornerRadius = 5
        return cell
    }
}
