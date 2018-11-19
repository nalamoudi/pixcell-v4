//
//  AccountTableTableViewController.swift
//  PixcellWorking
//
//  Created by Nahar Alamoudi on 11/5/18.
//  Copyright © 2018 Pixcell Inc. All rights reserved.
//

import UIKit
import Firebase

class AccountTableViewController: UIViewController {

    // Outlets
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var secondTableView: UITableView!
    
    // Constants
    let firstTableCellID = "firstCell"
    let secondTableCellID = "secondCell"
    let ref = Database.database().reference(fromURL: "https://pixcell-working.firebaseio.com/")
    let uid = Auth.auth().currentUser!.uid
    
    // Variables
    var firstMenu = ["Phone Number","Password"]
    var secondMenu = ["Total Albums Ordered", "Total Donations"]
    var userPhone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
        self.firstTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.secondTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let sv = UIViewController.displaySpinner(onView: self.view)
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            UIViewController.removeSpinner(spinner: sv)
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.userPhone = value?["Phone Number"] as? String ?? ""
        })
    }

    // MARK: - Table view data source

    
    func callDelegates () {
        firstTableView.delegate = self
        firstTableView.dataSource = self
        secondTableView.delegate = self
        secondTableView.dataSource = self
    }
}



extension AccountTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTableView {
            return firstMenu.count
        } else {
            return secondMenu.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == firstTableView {
            let cell = firstTableView.dequeueReusableCell(withIdentifier: firstTableCellID) as! accountCellView
            tableView.isScrollEnabled = false
            cell.configureCell(name:firstMenu[indexPath.row])
            self.firstTableView.tableFooterView = UIView(frame: CGRect.zero)
            return cell
        }else {
            let cell = secondTableView.dequeueReusableCell(withIdentifier: secondTableCellID) as! accountCellView2
            tableView.isScrollEnabled = false
            cell.configureCell(name: secondMenu[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            self.secondTableView.tableFooterView = UIView(frame: CGRect.zero)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == firstTableView {
            return "Account Info"
        } else {
            return "Account History"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == firstTableView {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "AccountDetailSegue", sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "PasswordChangeSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AccountDetailSegue" {
            if let dest = segue.destination as? UserPhoneNumberViewController{
                guard let userPhoneNum = self.userPhone else {return}
                dest.currentUserPhone = userPhoneNum
            }
        }
    }
    
}
    



