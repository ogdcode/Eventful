//
//  EventViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class EventViewController: UIViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
    
    @IBOutlet weak var titreLabel: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet var validerButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("dataManager object : \(managedObjectContext)")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchUpValider(_ sender: UIButton) {
        print("Titre:\(titreLabel.text)")
        print("Detail:\(detailTextView.text)")
        
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext!) as! Event
        event.titre = titreLabel.text
        event.eventDetail = detailTextView.text
        
        try? managedObjectContext?.save()
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
