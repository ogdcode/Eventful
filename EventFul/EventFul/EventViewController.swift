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
    
    @IBOutlet weak var newEventTitleLabel: UITextField!     // The new event title.
    @IBOutlet weak var newEventSynopsisView: UITextView!    // The new event synopsis.
    @IBOutlet weak var createEventButton: UIButton!         // A button to create an Event object with a title and a synopsis.
    
    var dataManager: DataManager?                           // The object managing the CoreData file.
    
    var firstSynopsisEdit: Bool?                            // A flag to manage a placeholder-like effect on the event synopsis UITableView.
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the DataManager object
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // Delegates for managing UITextField and UITextView actions
        self.newEventTitleLabel.delegate = self
        self.newEventSynopsisView.delegate = self
        
        // set this color for a placeholder-like effect
        self.newEventSynopsisView.textColor = UIColor.lightGray
        
        // set the flag as true to activate the placeholder-like effect
        self.firstSynopsisEdit = true
    }
    
    // MARK: - UITextFieldDelegate
    
    // when the user starts editing, the Create Event button
    // should be disabled to prevent them from creating
    // forbidden entries, like events with empty titles for example
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.createEventButton.isEnabled = false
    }
    
    // when the user stops editing, the system must check
    // that the event has a non-empty title, otherwise it
    // should not be possible to validate the creation of the event
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.checkValidEventTitle() {
            self.navigationItem.title = self.newEventTitleLabel.text
            
            if  self.checkValidEventSynopsis() &&
                !self.firstSynopsisEdit! {
                
                self.createEventButton.isEnabled = true
                
            }
        } else {
            self.navigationItem.title = "Mon évènement"
        }
    }
    
    // the user must tap the Done key on their keyboard to exit the field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    // when the user starts editing, the text must be recolored
    // to indicate that the view is active
    // however, only the first edit makes the 'placeholder' text
    // disappear. Every subsequent text is from the user, and
    // therefore should not be deleted automatically
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.firstSynopsisEdit! {
            self.newEventSynopsisView.text = ""
            self.firstSynopsisEdit = false
        }
        self.newEventSynopsisView.textColor = UIColor.black
        
        return true
    }
    
    // when the user starts editing, the Create Event button
    // should be disabled to prevent them from creating
    // forbidden entries, like events with empty synopses for example
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.createEventButton.isEnabled = false
    }
    
    // when the user stops editing, the system must check
    // that the event has a non-empty synopsis, otherwise it
    // should not be possible to validate the creation of the event
    func textViewDidEndEditing(_ textView: UITextView) {
        if  self.checkValidEventSynopsis() &&
            self.checkValidEventTitle() {
            
            self.createEventButton.isEnabled = true
            
        }
    }
    
    // the user must tap the Done key on their keyboard to exit the view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.newEventSynopsisView.textColor = UIColor.lightGray
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    // disable the Create Event button if the event title field is empty
    func checkValidEventTitle() -> Bool {
        let text = self.newEventTitleLabel.text ?? ""
        return !text.isEmpty
    }
    
    // disable the Create Event button if the event synopsis field is empty
    func checkValidEventSynopsis() -> Bool {
        let text = self.newEventSynopsisView.text ?? ""
        return !text.isEmpty
    }

    @IBAction func onTouchUpValider(_ sender: UIButton) {
        // insert a new Event object in the CoreData store
        // and go back to the event list
        if (self.dataManager?.createEvent(self.newEventTitleLabel.text, self.newEventSynopsisView.text))! {
            if let navCtrl: UINavigationController = self.navigationController {
                navCtrl.popViewController(animated: true)
            }
        } else {
            fatalError("Create object failed")
        }
    }

}
