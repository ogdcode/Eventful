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

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
    
    @IBOutlet weak var titreLabel: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var validerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("dataManager object : \(managedObjectContext)")
        
        self.titreLabel.delegate = self
        self.detailTextView.delegate = self
        
        self.checkEventValidTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
    func checkEventValidTitle() {
        
        let titreText = self.titreLabel.text ?? ""
        self.validerButton.isEnabled = !(titreText.isEmpty)
    }
    
    func saveEventData() {
        
        print("Titre:\(titreLabel.text)")
        print("Detail:\(detailTextView.text)")
        
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext!) as! Event
        event.titre = titreLabel.text
        event.eventDetail = detailTextView.text
        
        try? managedObjectContext?.save()
        
    }
    
    @IBAction func onTouchUpValider(_ sender: UIButton) {
        
       self.saveEventData()
        
       self.navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
