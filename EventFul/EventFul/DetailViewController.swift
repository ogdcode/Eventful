//
//  DetailViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 06/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet weak var detailTextView: UITextView!
    
    var eventDetail:Event!

    //var detaitText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = eventDetail.titre
        self.detailTextView.text = self.eventDetail.eventDetail
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

    @IBAction func deleteEvent(_ sender: AnyObject) {
        
        self.deleteEventData(context: managedObjectContext)
        
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
