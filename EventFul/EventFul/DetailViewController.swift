//
//  DetailViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 06/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var eventTitleLabel: UITextField!                // The event title.
    @IBOutlet weak var eventSynopsisView: UITextView!               // The event synopsis (description)
    @IBOutlet weak var addEventToFavoritesButton: UIButton!         // A button to change the favorite status of the event.
    @IBOutlet weak var editEventButton: UIButton!                   // A button to validate edits made to the event.
    
    let favIcon: UIImage = UIImage(named: "fav_true_button")!       // The icon used for events marked as favorite by the user.
    let notFavIcon: UIImage = UIImage(named: "fav_false_button")!   // The icon used for events not marked as favorite by the user.
    
    var dataManager: DataManager?                                   // The object managing the CoreData file.
    
    var event: Event!                                               // The Event object passed from the event list.

    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the DataManager object
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // set the navigation item title as the event title
        // and also set the event synopsis view as the
        // registered synopsis of the event in the database
        self.navigationItem.title = self.event.title
        self.eventTitleLabel.text = self.event.title
        self.eventSynopsisView.text = self.event.synopsis
        
        // set this color for a placeholder-like effect
        self.eventSynopsisView.textColor = UIColor.lightGray
        
        // Delegates for managing UITextField and UITextView actions
        self.eventTitleLabel.delegate = self
        self.eventSynopsisView.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    // when the user starts editing, the Edit Event button
    // should be disabled to prevent them from editing
    // forbidden entries, like empty titles for example
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editEventButton.isEnabled = false
    }
    
    // when the user stops editing, the system must check
    // that the event has a non-empty title, otherwise it 
    // should not be possible to validate the changes
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.checkValidEventTitle() {
            self.navigationItem.title = self.eventTitleLabel.text
            
            if self.checkValidEventSynopsis() {
                self.editEventButton.isEnabled = true
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.eventSynopsisView.textColor = UIColor.black
        return true
    }
    
    // when the user starts editing, the Edit Event button
    // should be disabled to prevent them from editing
    // forbidden entries, like empty synopses for example
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.editEventButton.isEnabled = false
    }
    
    // when the user stops editing, the system must check
    // that the event has a non-empty synopsis, otherwise it
    // should not be possible to validate the changes
    func textViewDidEndEditing(_ textView: UITextView) {
        if  self.checkValidEventSynopsis() &&
            self.checkValidEventTitle() {
            
            self.editEventButton.isEnabled = true
            
        }
    }
    
    // the user must tap the Done key on their keyboard to exit the view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.eventSynopsisView.textColor = UIColor.lightGray
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    // disable the Edit Event button if the event title field is empty
    func checkValidEventTitle() -> Bool {
        let text = self.eventTitleLabel.text ?? ""
        return !text.isEmpty
    }
    
    // disable the Edit Event button if the event synopsis field is empty
    func checkValidEventSynopsis() -> Bool {
        let text = self.eventSynopsisView.text ?? ""
        return !text.isEmpty
    }
    
    // set icon according to the event being marked as favorite or not
    func setFavorites() {
        let eventIsFavorited: Bool = self.event.isFavorited
        let icon: UIImage = eventIsFavorited ? self.favIcon : self.notFavIcon
        self.addEventToFavoritesButton.setImage(icon, for: .normal)
    }
    
    @IBAction func deleteEvent(_ sender: AnyObject) {
        // search for the event in the CoreData store
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        
        // delete the event from the store and go back to the event list
        if (self.dataManager?.deleteEvent(self.event, predicate))! {
            if let navCtrl: UINavigationController = self.navigationController {
                navCtrl.popViewController(animated: true)
            }
        } else {
            fatalError("Delete failed")
        }
    }
    
    @IBAction func addEventToFavorites(_ sender: AnyObject) {
        // search for the event in the CoreData store
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        
        // edit the favorite status event and save it in the store
        if (self.dataManager?.setEventFavorite(self.event, predicate, !self.event.isFavorited))! {
            self.setFavorites()
        } else {
            fatalError("Set isFavorited failed")
        }
    }
    
    @IBAction func editEvent(_ sender: AnyObject) {
        // search for the event in the CoreData store
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        // get the event to edit from the store
        let toEdit: Event! = self.dataManager?.readOrUpdateEvent(self.event, predicate)
        
        // if not nil, then a matching event has been found
        // edit its title and synopsis according to the label and view
        // then save the edited event in the CoreData store
        // and then go back to the event list
        if toEdit != nil {
            toEdit.title = self.eventTitleLabel.text
            toEdit.synopsis = self.eventSynopsisView.text
            if (self.dataManager?.save())! {
                if let navCtrl: UINavigationController = self.navigationController {
                    navCtrl.popViewController(animated: true)
                }
            }
        } else {
            fatalError("Update failed")
        }
    }
}
