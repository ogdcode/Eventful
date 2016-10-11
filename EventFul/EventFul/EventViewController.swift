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
    
    let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates for managing UITextField and UITextView actions
        self.titreLabel.delegate = self
        self.detailTextView.delegate = self
        
        self.checkEventValidTitle()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.validerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkEventValidTitle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    func checkEventValidTitle() {
        let titreText: String = self.titreLabel.text ?? ""
        self.validerButton.isEnabled = !(titreText.isEmpty)
    }
    
    func saveEventData() {
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
        event.titre = titreLabel.text
        event.eventDetail = detailTextView.text
        
        try? self.managedObjectContext.save()
    }
    
    @IBAction func onTouchUpValider(_ sender: UIButton) {
        self.saveEventData()
        if let navCtrl: UINavigationController = self.navigationController {
            navCtrl.popViewController(animated: true)
        }
    }

}
