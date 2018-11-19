//
//  CharityViewController.swift
//  PixcellWorking
//
//  Created by Muaawia Janoudy on 2018-11-07.
//  Copyright © 2018 Pixcell Inc. All rights reserved.
//

import UIKit
import Firebase

class CharityViewController: UIViewController {
    
    let ref = Database.database().reference(fromURL: "https://pixcell-working.firebaseio.com/")
    let uid = Auth.auth().currentUser!.uid
    
    
    var openPawsTotal: Double?
    var IHYAATotal: Double?
    var UNRefugeeAgencyTotal: Double?
    var amountOwed: Double?
    var albumsOrdered: Int?
    var charityOwed: Double {
        var amountToCharity = 0.00
        if let amountToBePaid = amountOwed {
            if amountToBePaid == 29.99 {
                amountToCharity = 28.99 * 0.05
            } else {
                amountToCharity = 57.98 * 0.05
            }
        }
        return amountToCharity
    }
    var didSubmit: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        let ac = UIAlertController(title: "Please Select a Charity", message: "Pixcell will donate money on your behalf to a charity you choose!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Proceed to Select", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.ref.child("charities").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let openPawsCurrentMoney = value?["Open Paws"] as? Double ?? 0
            let IHYAACurrentMoney = value?["IHYAA"] as? Double ?? 0
            let UNCurrentMoney = value?["UN Refugee Agency"] as? Double ?? 0
            self.openPawsTotal = openPawsCurrentMoney
            self.IHYAATotal = IHYAACurrentMoney
            self.UNRefugeeAgencyTotal = UNCurrentMoney
        })
        self.ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.albumsOrdered = value?["Total Albums To Date"] as? Int ?? 0
        })
    }
    
    @IBAction func firstCharityButton(_ sender: Any) {
        guard let openPawsCharity = openPawsTotal, let albumsToDate = self.albumsOrdered else {return}
        self.ref.child("charities/Open Paws").setValue(openPawsCharity + charityOwed)
        self.ref.child("users/\(uid)/Submitted").setValue(true)
        if charityOwed == 28.99 * 0.05 {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 1)
        } else {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 2)
        }
        performSegue(withIdentifier: "HomePageSegue", sender: self)
    }
    
    @IBAction func secondCharityButton(_ sender: Any) {
        guard let UNRefugeeCharity = UNRefugeeAgencyTotal, let albumsToDate = self.albumsOrdered else {return}
        self.ref.child("charities/UN Refugee Agency").setValue(UNRefugeeCharity + charityOwed)
        self.ref.child("users/\(uid)/Submitted").setValue(true)
        if charityOwed == 28.99 * 0.05 {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 1)
        } else {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 2)
        }
        performSegue(withIdentifier: "HomePageSegue", sender: self)
    }
    
    @IBAction func thirdCharityButton(_ sender: Any) {
        guard let IHYAACharity = IHYAATotal, let albumsToDate = self.albumsOrdered else {return}
        self.ref.child("charities/IHYAA").setValue(IHYAACharity + charityOwed)
        self.ref.child("users/\(uid)/Submitted").setValue(true)
        if charityOwed == 28.99 * 0.05 {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 1)
        } else {
            self.ref.child("users/\(uid)/Total Albums To Date").setValue(albumsToDate + 2)
        }
        performSegue(withIdentifier: "HomePageSegue", sender: self)
    }
}
