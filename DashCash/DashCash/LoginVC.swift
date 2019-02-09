//
//  LoginVC.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    override func viewDidLoad() {
        setupUI()
    }
    private func setupUI() {
        let viewSize = view.frame.size
        let titleImage = UIImage(named: "")
        let title = UIImageView(image: titleImage)
        let imageRatio: CGFloat = 3/4
        title.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * imageRatio)
        
        
        
        view.addSubview(title)
    }
}
