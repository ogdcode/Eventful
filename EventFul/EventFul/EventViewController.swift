//
//  EventViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class EventViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titreLabel: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var validerButton: UIButton!
    
    var dataManager: DataManager?
    var firstSynopsisEdit: Bool?
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Manager
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // set this color for a placeholder-like effect
        self.detailTextView.textColor = UIColor.lightGray
        
        // Delegates for managing UITextField and UITextView actions
        self.titreLabel.delegate = self
        self.detailTextView.delegate = self
        
        self.firstSynopsisEdit = true
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.validerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.checkValidEventTitle() {
            self.navigationItem.title = self.titreLabel.text
            
            if  self.checkValidEventSynopsis() &&
                !self.firstSynopsisEdit! {
                
                self.validerButton.isEnabled = true
                
            }
        } else {
            self.navigationItem.title = "Mon évènement"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.firstSynopsisEdit! {
            self.detailTextView.text = ""
            self.firstSynopsisEdit = false
        }
        self.detailTextView.textColor = UIColor.black
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.validerButton.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if  self.checkValidEventSynopsis() &&
            self.checkValidEventTitle() {
            
            self.validerButton.isEnabled = true
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.detailTextView.textColor = UIColor.lightGray
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    func checkValidEventTitle() -> Bool {
        // disable the validate button if the event title field is empty
        let text = self.titreLabel.text ?? ""
        return !text.isEmpty
    }
    
    func checkValidEventSynopsis() -> Bool {
        // disable the validate button if the event description field is empty
        let text = self.detailTextView.text ?? ""
        return !text.isEmpty
    }

    
    @IBAction func onTouchUpValider(_ sender: UIButton) {
        if (self.dataManager?.createEvent(self.titreLabel.text, self.detailTextView.text))! {
            print("Created object successfully")
            
            if let navCtrl: UINavigationController = self.navigationController {
                navCtrl.popViewController(animated: true)
            }
        } else {
            print("Create object failed")
        }
    }

}
