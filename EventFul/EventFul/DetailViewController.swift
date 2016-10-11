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
    
    var managedObjectContext: NSManagedObjectContext?
    var dataManager: DataManager?
    
    let eventEntity: String = "Event"
    var eventDetail: Event!
    var eventArray: [Event] = [Event]()
    
    let imageFavorisTrue: UIImage = UIImage(named: "fav_true_button")!
    let imageFavorisFalse: UIImage = UIImage(named: "fav_false_button")!
    var isModifier: Bool = false

    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        self.navigationItem.title = eventDetail.titre
        self.detailTextView.text = self.eventDetail.eventDetail
        
        // Delegates for managing UITextField and UITextView actions
        self.detailTextView.delegate = self
        self.titreTextView.delegate = self
        
        let eventFavoris: Bool = self.eventDetail.favoris
        let imageFavoris: UIImage = eventFavoris ? self.imageFavorisTrue : self.imageFavorisFalse
        self.favorisButton.setImage(imageFavoris, for: .normal)
        
        if !self.isModifier {
            self.sauvegardButton.isHidden = true
            self.titreTextView.isHidden = true
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.isModifier
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.isModifier
    }

    // MARK: - Actions

    func deleteEventData(_ context: NSManagedObjectContext?) {
        
        let request: NSFetchRequest = NSFetchRequest<Event>(entityName: self.eventEntity)
        let predicateEvent: NSPredicate = NSPredicate(format: "self == %@", eventDetail.objectID)
        request.predicate = predicateEvent

        let events: [Event] = try! (context?.fetch(request))!
        
        for event in events {
            context?.delete(event)
        }
        
        try? self.managedObjectContext?.save()
    }
    
    func updateEventData(_ context: NSManagedObjectContext?, _ event: Event) {
        
        let request: NSFetchRequest = NSFetchRequest<Event>(entityName: self.eventEntity)
        let predicateEvent: NSPredicate = NSPredicate(format: "self == %@", event.objectID)
        request.predicate = predicateEvent
        
        let events: [Event] = try! (context?.fetch(request))!
        
        let eventFetched: Event = events.first!
        eventFetched.favoris = !eventFetched.favoris
        
        try? self.managedObjectContext?.save()
    }
    
    @IBAction func deleteEvent(_ sender: AnyObject) {
        
        self.deleteEventData(self.managedObjectContext)
        
        if let navCtrl: UINavigationController = self.navigationController {
            navCtrl.popViewController(animated: true)
        }
    }
    
    
    @IBAction func addEventToFavorites(_ sender: AnyObject) {
        self.updateEventData(self.managedObjectContext, self.eventDetail)
        
        let eventFavoris: Bool = self.eventDetail.favoris
        let imageFavoris: UIImage = eventFavoris ? self.imageFavorisTrue : self.imageFavorisFalse
        self.favorisButton.setImage(imageFavoris, for: .normal)

    }
}
