//
//  ListViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var eventTableView: UITableView!
    
    let imageFavorisTrue: UIImage = UIImage(named: "fav_true_button")!
    let imageFavorisFalse: UIImage = UIImage(named: "fav_false_button")!
    
    var dataManager: DataManager?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    let eventEntity: String = "Event"
    var eventArray: [Event]? = [Event]()
    var favorisIsTapped: Bool = false
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Manager
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // Auto-refresh
        self.refreshControl.attributedTitle = NSAttributedString(string: "Rechargement")
        self.refreshControl.addTarget(self, action: #selector(self.refreshTableView), for: UIControlEvents.valueChanged)
        self.eventTableView.addSubview(refreshControl)
        
        // Delegates for managing UITableView
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        // Change back button of navigation bar in NavigationController
        let backButton: String = "back_button"
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: backButton)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: backButton)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    // MARK: - UITableView
    
    func refreshTableView() {
        
        self.eventArray?.removeAll()
        self.eventArray = self.dataManager?.readAllEvents()
        self.eventTableView.reloadData()
        
        // tell refresh control it can stop showing up now
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.eventArray?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID: String = "EventCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventTableViewCell
        let event: Event = self.eventArray![indexPath.row]
        
        let eventFavoris: Bool = event.isFavorited
        let imageFavoris: UIImage = (eventFavoris ? imageFavorisTrue : imageFavorisFalse)
        
        cell.favorisButton.setImage(imageFavoris, for: .normal)
        
        cell.titreTableViewCell.text = event.title

        // tags allow to retrieve the Event object when tapping on an action button
        cell.modifierButton.tag = indexPath.row
        cell.supprimerButton.tag = indexPath.row
        cell.favorisButton.tag = indexPath.row
        
        // programatically create segues for the action buttons
        cell.modifierButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.supprimerButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.favorisButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    // MARK: - Actions
    
    func eventCellAction(_ sender: UIButton!){
        let detailVCID: String = "detailEvent"
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: detailVCID) as! DetailViewController
        
        let event: Event = eventArray![sender.tag]
        let predicate: NSPredicate = NSPredicate(format: "title = %@", event.title!)
        
        switch (sender.titleLabel?.text)! {
            case "Modifier":
                detailViewController.event = event
                navigationController?.pushViewController(detailViewController, animated: true)
                
                break
            case "Supprimer":
                if (self.dataManager?.deleteEvent(event, predicate))! {
                    print("Delete successful")
                    self.refreshTableView()
                } else {
                    print("Delete failed")
                }
                
                break
            case "Favoris":
                print(event.title)
                if (self.dataManager?.setEventFavorite(event, predicate, !event.isFavorited))! {
                    print("Set isFavorited to \(!event.isFavorited) successfully")
                    self.refreshTableView()
                } else {
                    print("Set isFavorited failed")
                }
                
                break
            default:
                break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailEventSegueID: String = "detailEventSegue"
        
        if segue.identifier == detailEventSegueID {
            if let cell = sender as? EventTableViewCell {
                let detailViewController = segue.destination as! DetailViewController
                
                let row: Int = self.eventTableView.indexPath(for: cell)!.row
                let event: Event = eventArray![row]
                
                detailViewController.event = event
            }
        }
    }
}
