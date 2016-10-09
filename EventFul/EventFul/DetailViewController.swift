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

    var managedObjectContext:NSManagedObjectContext?
    var dataManager:DataManager?
    var eventDetail:Event!
    var eventArray:[Event] = []
    
    let imageFavorisTrue = UIImage(named: "fav_true_button")
    let imageFavorisFalse = UIImage(named: "fav_false_button")
    var isModifier:Bool = false
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var titreTextView: UITextField!
    @IBOutlet weak var favorisButton: UIButton!
    @IBOutlet weak var sauvegardButton: UIButton!


    //var detaitText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = eventDetail.titre
        self.detailTextView.text = self.eventDetail.eventDetail
        
        self.detailTextView.delegate = self
        self.titreTextView.delegate = self
        
        let eventFavoris = self.eventDetail.favoris
        let imageFavoris = eventFavoris ? imageFavorisTrue : imageFavorisFalse
        self.favorisButton.setImage(imageFavoris, for:.normal)
        
        if !isModifier {
            
            self.sauvegardButton.isHidden = true
            self.titreTextView.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func deleteEventData(context:NSManagedObjectContext?) {
        
        print("context:\(context)")
        let request = NSFetchRequest<Event>(entityName: "Event")
        let predicateEvent = NSPredicate(format: "self == %@", eventDetail.objectID)
        request.predicate = predicateEvent

        let events = try?(context?.fetch(request))!
        
        for event in events! {
            
            print("Delete event:\(event)")
            context?.delete(event)
        }
        
        try? managedObjectContext?.save()
    }
    
    func updateEventData(context:NSManagedObjectContext?, event:Event) {
        
        print("context:\(context)")
        let request = NSFetchRequest<Event>(entityName: "Event")
        let predicateEvent = NSPredicate(format: "self == %@", event.objectID)
        request.predicate = predicateEvent
        
        let event = try?(context?.fetch(request))!
        
        let eventFetched  = event!.first
        eventFetched!.favoris = !eventFetched!.favoris
        
        try? managedObjectContext?.save()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if isModifier {
            return true
        }
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if isModifier {
            return true
        }
        return false
    }
    
    @IBAction func deleteEvent(_ sender: AnyObject) {
        
        self.deleteEventData(context: managedObjectContext)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addEventToFavorites(_ sender: AnyObject) {
        self.updateEventData(context:managedObjectContext, event:eventDetail)
        
        let eventFavoris = self.eventDetail.favoris
        let imageFavoris = eventFavoris ? imageFavorisTrue : imageFavorisFalse
        self.favorisButton.setImage(imageFavoris, for:.normal)

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
