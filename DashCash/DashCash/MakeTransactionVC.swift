//
//  MakeTransactionVC.swift
//  DashCash
//
//  Created by Rahil Patel on 2/9/19.
//  Copyright © 2019 DashCash. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class MakeTransactionVC: UIViewController, UserDataProtocol {
    var userData: UserData?
    
    @IBOutlet weak var segController: UISegmentedControl!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    var segControllerState = true
    
    override func viewDidLoad() {
        layoutUI()
    }
    private func layoutUI() {
        var size = CGSize(width: txtField.frame.width, height: txtField.frame.height * 2)
        txtField.font = UIFont(name: txtField.font!.fontName, size: txtField.font!.pointSize * 2)
        txtField.textAlignment = .center
        txtField.frame = CGRect(origin: txtField.frame.origin, size: size)
        segController.tintColor = Colors.orange
        segController.addTarget(self, action: #selector(segControllerToggled(_:)), for: .touchUpInside)
        size = CGSize(width: submitBtn.frame.width, height: submitBtn.frame.height * 2)
        submitBtn.frame = CGRect(origin: submitBtn.frame.origin, size: size)
        submitBtn.backgroundColor = Colors.orange
        submitBtn.setTitleColor(Colors.textColor, for: .normal)
        submitBtn.layer.cornerRadius = 10
        submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var dest = segue.destination as? UserDataProtocol {
            print("\n\nBALANCE:\n")
            print(userData?.balance)
            dest.userData = userData
        }
    }
    
    @objc private func segControllerToggled(_ sender: Any) {
        
    }
    
    @objc private func backTapped(_ sender: Any) {
        let dbURL = URL(string: "http://157.230.170.230:3000/Users/\(userData!.userName)?token=\(Tokens.userAuthToken)")
        var dbRequest = URLRequest(url: dbURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        dbRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: dbRequest, completionHandler: { (data, response, error) in
            // Remove loading icon
            self.removeSpinner()
            // Set the user data to the retrieved data.
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let updatedData = json as! [String : Any]
                let updatedUser = UserData(data: updatedData)
                self.userData = updatedUser
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "PayToHomeSegue", sender: sender)
                }
            } catch {
                
            }
        })
        
        // Displays the loading spinner animation
        self.showSpinner(onView: self.view)
        task.resume()
    }
    
    // Sends the backend all the information it needs to
    // validate payment and update the database.
    @objc private func submitTapped(_ sender: Any) {
        let dbURL = URL(string: "http://157.230.170.230:3000/pay")
        var dbRequest = URLRequest(url: dbURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let httpBody = try? JSONSerialization.data(withJSONObject: ["amount":txtField.text!, "user":userData!.userName])
        dbRequest.httpBody = httpBody
        dbRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        dbRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        dbRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: dbRequest, completionHandler: { (data, response, error) in
            // Remove loading icon
            self.removeSpinner()
            // Set the user data to the retrieved data.
            guard let data = data else {
                return
            }
            do {

                let httpResponse = response as! HTTPURLResponse
                
                // Opens an embedded browser for the user to sign into PayPal
                if let url = httpResponse.url {
                    let svc = SFSafariViewController(url: url)
                    DispatchQueue.main.async {
                        self.present(svc, animated: true, completion: nil)
                    }
                } else {
                    let paymentDeniedAlertController = UIAlertController(title: "Payment unsuccessful", message: "For some reason, the payment did not go through. Contanct support or try again later.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        paymentDeniedAlertController.dismiss(animated: true, completion: nil)
                    })
                    DispatchQueue.main.async {
                        paymentDeniedAlertController.addAction(okAction)
                        self.present(paymentDeniedAlertController, animated: true, completion: nil)
                    }
                }
            } catch {
                
            }
        })
        // Show the spinning loading icon
        self.showSpinner(onView: self.view)
        task.resume()
    }
}
