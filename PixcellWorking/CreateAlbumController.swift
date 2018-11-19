//
//  LoggedInViewController.swift
//  PixcellWorking
//
//  Created by Muaawia Janoudy on 2018-10-17.
//  Copyright © 2018 Pixcell Inc. All rights reserved.
//

//This controller is what the user sees after logging in and/or finishing picking their photos

import UIKit
import Firebase


class CreateAlbumController: UIViewController {
    
    var remainingImagesCounter: Int?
    var secondAlbumRemainingImagesCounter: Int?
    var submitted: Bool?
    var secondAlbumName: String?
    var delivered: Bool?
    
    let firstAlbumSegueIdentifier = "First Album Segue"
    let secondAlbumSegueIdentifier = "Second Album Segue"
    
    // Creating Firebase Reference for Read/Write Operations
    let ref = Database.database().reference(fromURL: "https://pixcell-working.firebaseio.com/")
    let uid = Auth.auth().currentUser!.uid

    @IBOutlet var firstAlbumStatusLabel: UILabel!
    @IBOutlet var firstAlbumObject: UIView!
    @IBOutlet var firstAlbumNameLabel: UILabel!
    @IBOutlet var secondAlbumObject: UIView!
    @IBOutlet var secondAlbumNameLabel: UILabel!
    @IBOutlet var secondAlbumStatusLabel: UILabel!
    @IBOutlet var addAlbumButtonPressed: UIButton!
    @IBOutlet weak var firstAlbumSelectedButton: UIButton!
    @IBOutlet weak var secondAlbumSelectedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAlbumButtonPressed.layer.cornerRadius = 10
        addAlbumButtonPressed.layer.borderWidth = 1
        addAlbumButtonPressed.layer.borderColor = UIColor.init(red: 230, green: 230, blue: 230).cgColor
        self.hideKeyboardWhenTappedAround()
        firstAlbumObject.isHidden = true
        secondAlbumObject.isHidden = true
        firstAlbumObject.layer.cornerRadius = 10
        secondAlbumObject.layer.cornerRadius = 10
        firstAlbumNameLabel.text = "\(Date().getMonthName())"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*self.ref.child("users").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let remainingImagesFirstAlbum = value?["Remaining Photos"] as? Int ?? 0
            let remainingImagesSecondAlbum = value?["Extra Album Remaining Photos"] as? Int ?? 0
            self.remainingImagesCounter = remainingImagesFirstAlbum
            self.secondAlbumRemainingImagesCounter = remainingImagesSecondAlbum
            self.secondAlbumNameLabel.text = value?["Second Album Name"] as? String ?? "Other Album"
            let deliveredValue = value?["Delivered"] as? Bool ?? false
            let submitted = value?["Submitted"] as? Bool ?? false*/
        guard let remainingImagesFirstAlbum = self.remainingImagesCounter, let remainingImagesSecondAlbum = self.secondAlbumRemainingImagesCounter, let deliveredValue = self.delivered, let secondAlbumName = self.secondAlbumName else {return}
            self.secondAlbumNameLabel.text = secondAlbumName
            self.firstAlbumStatusLabel.text = "\(50-remainingImagesFirstAlbum)/50"
            self.secondAlbumStatusLabel.text = "\(50-remainingImagesSecondAlbum)/50"
            if remainingImagesFirstAlbum < 50 {
                self.firstAlbumObject.isHidden = false
            }
            if remainingImagesSecondAlbum < 50  {
                self.secondAlbumObject.isHidden = false
            }
            if deliveredValue == true && remainingImagesSecondAlbum == 50 && submitted == true{
                self.firstAlbumStatusLabel.text = "Delivered"
                self.firstAlbumSelectedButton.isEnabled = false
            } else if deliveredValue == true && remainingImagesSecondAlbum < 50 && submitted == true  {
                self.firstAlbumStatusLabel.text = "Delivered"
                self.secondAlbumStatusLabel.text = "Delivered"
                self.firstAlbumSelectedButton.isEnabled = false
                self.secondAlbumSelectedButton.isEnabled = false
            }
            if submitted == true && deliveredValue == false && self.secondAlbumNameLabel!.text != "empty" {
                self.firstAlbumStatusLabel.text = "On the way"
                self.secondAlbumStatusLabel.text = "On the way"
                self.firstAlbumSelectedButton.isEnabled = false
                self.secondAlbumSelectedButton.isEnabled = false
            } else if submitted == true && deliveredValue == false && self.secondAlbumNameLabel!.text == "empty" {
                self.firstAlbumStatusLabel.text = "On the way"
                self.firstAlbumSelectedButton.isEnabled = false
            }
        //})
    }
    
    //display an error message as a UIAlertController
    func displayErrorMessage(message: String) {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in }
        alertView.addAction(okAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    

    
    //Logout IBAction to sign the user out. The Auth.auth() method is part of the Firebase pod.
    

    
    @IBAction func firstAlbumSelectImages(_ sender: Any) {
           performSegue(withIdentifier: "FirstAlbumPickImagesSegue", sender: UIButton.self)
        
    }
    
    @IBAction func secondAlbumSelectImages(_ sender: Any) {
        performSegue(withIdentifier: "SecondAlbumPickImagesSegue", sender: UIButton.self)
    }
    
    @IBAction func addAlbumButtonPressed(_ sender: Any) {
        if firstAlbumObject.isHidden {
            performSegue(withIdentifier: "FirstAlbumPickImagesSegue", sender: UIButton.self)
        } else if firstAlbumObject.isHidden == false && secondAlbumObject.isHidden == false {
            displayErrorMessage(message: "You have already used the 2 album limit")
        } else if !firstAlbumObject.isHidden && remainingImagesCounter == 0 {
            let nameSelectionAlert = UIAlertController(title: "Pick a name for your extra Album", message: nil, preferredStyle: .alert)
            nameSelectionAlert.addTextField { (textField) in
                textField.placeholder = "Enter Album Name Here"
                textField.enablesReturnKeyAutomatically = true
            }
            nameSelectionAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                guard let name = nameSelectionAlert.textFields![0].text else {
                    return
                }
                self.secondAlbumNameLabel.text = name
                self.ref.child("users/\(self.uid)/Second Album Name").setValue(name)
                self.performSegue(withIdentifier: "SecondAlbumPickImagesSegue", sender: UIButton.self)
            }))
            present(nameSelectionAlert, animated: true)
        }
    }
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Checkout", message: "Are you sure you want to checkout?", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "Yes I want to Checkout", style: .default, handler: { action in
            self.performSegue(withIdentifier: "CheckOutSegue", sender: self)
        })
        ac.addAction(option1)
        if let remainingImages = self.remainingImagesCounter {
            if remainingImages < 50 {
                let option2 = UIAlertAction(title: "No, I want to select more images", style: .default, handler: nil)
                ac.addAction(option2)
            } else if remainingImages == 0 {
                if let secondAlbumRemaining = self.secondAlbumRemainingImagesCounter {
                    if secondAlbumRemaining < 50 && secondAlbumRemaining > 0 {
                        let option2 = UIAlertAction(title: "No, I want to select more images for my second album", style: .default, handler: nil)
                        ac.addAction(option2)
                    } else {
                        let option2 = UIAlertAction(title: "cancel", style: .default, handler: nil)
                        ac.addAction(option2)
                    }
                }
            }
        }
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imagesRemaining = remainingImagesCounter else {return}
        guard let secondImagesRemainingCounter = secondAlbumRemainingImagesCounter else {return}
        if segue.identifier == "FirstAlbumPickImagesSegue" && imagesRemaining <= 50 {
            if let dest = segue.destination as? CustomAssetCellController {
                dest.imagesRemaining = imagesRemaining
                dest.firstAlbumSegueIdentifier = firstAlbumSegueIdentifier
            }
        } else if segue.identifier == "SecondAlbumPickImagesSegue" && imagesRemaining == 0 && secondImagesRemainingCounter <= 50 {
            if let dest = segue.destination as? CustomAssetCellController {
                dest.secondAlbumImagesRemaining = secondImagesRemainingCounter
                dest.secondAlbumSegueIdentifier = secondAlbumSegueIdentifier                
            }
        } else if segue.identifier == "CheckOutSegue" {
            if let dest = segue.destination as? AddressPaymentViewController {
                dest.firstAlbumRemainingImages = imagesRemaining
                dest.secondAlbumRemainingImages = secondImagesRemainingCounter
                if imagesRemaining == 0 && secondImagesRemainingCounter < 50 && secondImagesRemainingCounter >= 0 {
                    dest.albumsCost = 59.98
                } else {
                    dest.albumsCost = 29.99
                }
            }
        }
    }
}
