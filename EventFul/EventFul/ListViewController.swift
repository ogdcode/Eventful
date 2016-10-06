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
    //var refreshControl = UIRefreshControl ()
    
    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        /*self.refreshControl.attributedTitle = NSAttributedString(string: "Rechargement")
        self.refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControlEvents.valueChanged)
        self.eventTableView.addSubview(refreshControl)
        */
        
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).dataManager
        print("dataManager object : \(managedObjectContext)")
        self.loadEventData(context: managedObjectContext)
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventArray.removeAll()
        self.loadEventData(context: managedObjectContext)
        self.eventTableView.reloadData()
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
    
    func refresh(sender:AnyObject) {
        
        self.loadEventData(context: managedObjectContext)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = eventTableView.cellForRow(at: indexPath)
        eventTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailEventSegue", sender: cell)
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
