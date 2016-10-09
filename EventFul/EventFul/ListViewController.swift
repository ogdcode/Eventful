//
//  ListViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var managedObjectContext:NSManagedObjectContext?
    var eventArray:[Event] = []
    var refreshControl = UIRefreshControl()
    var favorisIsTapped = false
    
    let imageFavorisTrue = UIImage(named: "fav_true_button")
    let imageFavorisFalse = UIImage(named: "fav_false_button")
    
    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        //Auto-refresh
        self.refreshControl.attributedTitle = NSAttributedString(string: "Rechargement")
        self.refreshControl.addTarget(self, action:#selector(self.refreshTableView), for: UIControlEvents.valueChanged)
        self.eventTableView.addSubview(refreshControl)
        
        //Access delegate of singleton UIApplication
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        print("dataManager object : \(managedObjectContext)")
        
        
        //Delegates
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        //Load data from SQLite DB
        self.loadEventData(context: managedObjectContext)

        
        //Change back button of navigation controller
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let cell = sender as? UITableViewCell {
            let row = eventTableView.indexPath(for: cell)!.row
            
            if segue.identifier == "detailEventSegue" {
                
                let detailViewController = segue.destination as! DetailViewController
                let event = eventArray[row]
                
                print("Detail titre\(event.titre)")
                print("Detail text\(event.eventDetail)")
                
                detailViewController.eventDetail = event
            }
        }
        

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
    
    func refreshTableView() {
        
        eventArray.removeAll()
        self.loadEventData(context: managedObjectContext)
        self.eventTableView.reloadData()
        
        // tell refresh control it can stop showing up now
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
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
        
        let eventFavoris = event.favoris
        let imageFavoris = eventFavoris ? imageFavorisTrue : imageFavorisFalse
        
        cell.favorisButton.setImage(imageFavoris, for:.normal)
        
        cell.titreTableViewCell.text = event.titre

        cell.modifierButton.tag = indexPath.row
        cell.supprimerButton.tag = indexPath.row
        cell.favorisButton.tag = indexPath.row
        
        cell.modifierButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.supprimerButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.favorisButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = eventTableView.cellForRow(at: indexPath)
        eventTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailEventSegue", sender: cell)
    }
    

    func eventCellAction(sender:UIButton!){

        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "detailEvent") as! DetailViewController
        
        print("Row tag:\(sender.tag)")
        let event = eventArray[sender.tag]
        
        if sender.titleLabel?.text == "Modifier" {
            
            print("Modifier Detail titre\(event.titre)")
            print("Modifier Detail text\(event.eventDetail)")
            
            detailViewController.eventDetail = event
            detailViewController.isModifier = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        else if sender.titleLabel?.text == "Supprimer" {
            
            print("Supprimer Detail titre\(event.titre)")
            print("Supprimer Detail text\(event.eventDetail)")
            
            self.deleteEventData(context: managedObjectContext, eventDetail: event)
            
            self.refreshTableView()
            
        }
        
        else if sender.titleLabel?.text == "Favoris" {
            
            print("Favoris Detail titre\(event.titre)")
            print("Favoris Detail text\(event.eventDetail)")
            
            self.updateEventData(context: managedObjectContext, event: event)
            
            self.refreshTableView()
        }
    }
    
    func deleteEventData(context:NSManagedObjectContext?, eventDetail:Event) {
        
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
