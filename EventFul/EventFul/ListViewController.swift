//
//  ListViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var managedObjectContext:NSManagedObjectContext?
    var eventArray:[Event] = []
    
    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTableView.dataSource = self
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        print("dataManager object : \(managedObjectContext)")
        loadEventData(context: managedObjectContext)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEventData(context:NSManagedObjectContext?) {
       
        let request = NSFetchRequest<Event>(entityName: "Event")
        print("context:\(context)")
        let events = try? (context?.fetch(request))!
        
        var i:Int = 0
        for e in events! {
            i += 1
            eventArray.append(e)
            print("fetch event:\(e.titre)")
            //print("event in eventArray:\(eventArray[i])")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventTableViewCell
        let event = eventArray[indexPath.row]
        
        cell.titreTableViewCell.text = event.titre
        
        return cell
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
