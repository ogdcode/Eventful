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

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var titreTextView: UITextField!
    @IBOutlet weak var favorisButton: UIButton!
    @IBOutlet weak var sauvegardButton: UIButton!
    
    var dataManager: DataManager?
    
    let eventEntity: String = "Event"
    var event: Event!
    
    let imageFavorisTrue: UIImage = UIImage(named: "fav_true_button")!
    let imageFavorisFalse: UIImage = UIImage(named: "fav_false_button")!

    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Manager
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        self.navigationItem.title = self.event.title
        self.titreTextView.text = self.event.title
        self.detailTextView.text = self.event.synopsis
        
        // set this color for a placeholder-like effect
        self.detailTextView.textColor = UIColor.lightGray
        
        // Delegates for managing UITextField and UITextView actions
        self.detailTextView.delegate = self
        self.titreTextView.delegate = self
        
        let eventFavoris: Bool = self.event.isFavorited
        let imageFavoris: UIImage = eventFavoris ? self.imageFavorisTrue : self.imageFavorisFalse
        self.favorisButton.setImage(imageFavoris, for: .normal)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sauvegardButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.checkValidEventTitle() {
            self.navigationItem.title = self.titreTextView.text
            
            if self.checkValidEventSynopsis() {
                self.sauvegardButton.isEnabled = true
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
        self.detailTextView.textColor = UIColor.black
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.sauvegardButton.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if  self.checkValidEventSynopsis() &&
            self.checkValidEventTitle() {
            
            self.sauvegardButton.isEnabled = true
            
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
        // disable the save button if the event title field is empty
        let text = self.titreTextView.text ?? ""
        return !text.isEmpty
    }
    
    func checkValidEventSynopsis() -> Bool {
        // disable the save button if the event description field is empty
        let text = self.detailTextView.text ?? ""
        return !text.isEmpty
    }
    
    @IBAction func deleteEvent(_ sender: AnyObject) {
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        if (self.dataManager?.deleteEvent(self.event, predicate))! {
            print("Delete successful")
            
            if let navCtrl: UINavigationController = self.navigationController {
                navCtrl.popViewController(animated: true)
            }
        } else {
            print("Delete failed")
        }
    }
    
    @IBAction func addEventToFavorites(_ sender: AnyObject) {
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        if (self.dataManager?.setEventFavorite(self.event, predicate, !self.event.isFavorited))! {
            print("Set isFavorited to \(!self.event.isFavorited) successfully")
            
            let eventFavoris: Bool = self.event.isFavorited
            let imageFavoris: UIImage = (eventFavoris ? self.imageFavorisTrue : self.imageFavorisFalse)
            self.favorisButton.setImage(imageFavoris, for: .normal)
        } else {
            print("Set isFavorited failed")
        }
    }
    
    @IBAction func editEvent(_ sender: AnyObject) {
        let predicate: NSPredicate = NSPredicate(format: "title = %@", self.event.title!)
        let toEdit: Event! = self.dataManager?.readOrUpdateEvent(self.event, predicate)
        if toEdit != nil {
            toEdit.title = self.titreTextView.text
            toEdit.synopsis = self.detailTextView.text
            self.dataManager?.save()
            print("Update successful")
            
            if let navCtrl: UINavigationController = self.navigationController {
                navCtrl.popViewController(animated: true)
            }
        } else {
            print("Update failed")
        }
    }
}
