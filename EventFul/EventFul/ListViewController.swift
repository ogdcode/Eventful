//
//  ListViewController.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class ListViewController:   UIViewController, UITableViewDataSource, UITableViewDelegate,
                            UISearchResultsUpdating {
    
    @IBOutlet weak var eventTableView: UITableView!                 // The list of events.
    
    let favIcon: UIImage = UIImage(named: "fav_true_button")!       // The icon used for events marked as favorite by the user.
    let notFavIcon: UIImage = UIImage(named: "fav_false_button")!   // The icon used for events not marked as favorite by the user.
    
    var dataManager: DataManager?                                   // The object managing the CoreData file.
    var refreshControl: UIRefreshControl = UIRefreshControl()       // An object managing view refreshing.
    var searchController: UISearchController!                       // A controller object managing the search bar.
    
    var events: [Event]? = [Event]()                                // The event array displayed through a UITableView object.
    var filteredEvents: [Event] = [Event]()                         // The event array when the search bar is empty.
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the DataManager object
        self.dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        // use auto-refresh
        self.refreshControl.attributedTitle = NSAttributedString(string: "Rechargement")
        self.refreshControl.addTarget(self, action: #selector(self.refreshTableView), for: UIControlEvents.valueChanged)
        self.eventTableView.addSubview(refreshControl)
        
        // set this UIViewController as UITableView data source and delegate
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        // change back button of navigation bar in NavigationController
        let backButton: String = "back_button"
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: backButton)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: backButton)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        
        // if this same view controller is used to present the results
        // dimming it out would not make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.eventTableView.tableHeaderView = searchController.searchBar
        
        // sets this view controller as presenting view controller for search interface
        self.definesPresentationContext = true
    }
    
    // this method is called every time the UIViewController becomes visible
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get the EventTableViewCell reuse identifier
        let cellID: String = "EventCell"
        
        // retrieve the cell from queue or create a new one with the reuse ID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventTableViewCell
        let event: Event = self.filteredEvents[indexPath.row]
        
        // set cell labels to match retrieved event
        cell.eventTitleLabel.text = event.title
        cell.eventSynopsisLabel.text = event.synopsis

        // tags allow to retrieve the Event object when tapping on an action button
        cell.editEventButton.tag = indexPath.row
        cell.deleteEventButton.tag = indexPath.row
        cell.addEventToFavoritesButton.tag = indexPath.row
        
        // set icon according to the event being marked as favorite or not
        let eventIsFavorited: Bool = event.isFavorited
        let icon: UIImage = (eventIsFavorited ? self.favIcon : self.notFavIcon)
        cell.addEventToFavoritesButton.setImage(icon, for: .normal)

        
        // programatically create segues for the action buttons
        cell.editEventButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.deleteEventButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        cell.addEventToFavoritesButton.addTarget(self, action: #selector(self.eventCellAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // launch search only if there is text in the search bar
        if let searchText = searchController.searchBar.text {
            
            // empty searchText means whitespaces in this context
            self.filteredEvents = (searchText.isEmpty ? self.events : self.events?.filter({(event: Event) -> Bool in
                
                // events which titles are similar in syntax to the entered text
                // will be displayed on screen to the user. Case insensitive because 
                // the user should have to type capital letters.
                return ((event.title?.range(of: searchText, options: .caseInsensitive)) != nil)
                
            }))!
            
            // reloading the UITableView object so that changes are acknowledged
            self.eventTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    func refreshTableView() {
        
        // update the event list in case modifications 
        // have been made in the event detail screen
        self.events?.removeAll()
        self.events = self.dataManager?.readAllEvents()
        self.filteredEvents = self.events!
        self.eventTableView.reloadData()
        
        // tell refresh control it can stop showing up now
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    func eventCellAction(_ sender: UIButton!){
        
        // get the event detail screen's unique identifier
        let detailVCID: String = "detailEvent"
        
        // retrieve the UIViewController object with the ID
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: detailVCID) as! DetailViewController
        
        // retrieve the event at the selected row
        let event: Event = events![sender.tag]
        let predicate: NSPredicate = NSPredicate(format: "self = %@", event.objectID)
        
        // different actions can be carried out
        // depending on which button of the cell
        // was tapped by the user
        switch (sender.titleLabel?.text)! {
            case "Modifier":
                detailViewController.event = event
                navigationController?.pushViewController(detailViewController, animated: true)
                
                break
            
            case "Supprimer":
                if (self.dataManager?.deleteEvent(event, predicate))! {
                    self.refreshTableView()
                } else {
                    print("Delete failed")
                }
                
                break
            
            // the icon was set a label so targeting it is easier
            case "Favoris":
                print(event.title)
                if (self.dataManager?.setEventFavorite(event, predicate, !event.isFavorited))! {
                    self.refreshTableView()
                } else {
                    fatalError("Set isFavorited failed")
                }
                
                break
            default:
                break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get the segue's identifier
        let detailEventSegueID: String = "detailEventSegue"
        
        // only the event detail page requires special treatment
        // accessing the new event page requires a simple view
        // controller push
        if segue.identifier == detailEventSegueID {
            
            // get the cell the user tapped on and, by use of let,
            // check if it is nil, if not cast it to EventTableViewCell
            if let cell = sender as? EventTableViewCell {
                
                // get the pushing UIViewController object and force cast it
                // so its member variables are accessible
                let detailViewController = segue.destination as! DetailViewController
                
                // get the event by its row in the UITableView
                let row: Int = self.eventTableView.indexPath(for: cell)!.row
                let event: Event = events![row]
                
                // carry the event information to the next UIViewController object
                detailViewController.event = event
            }
        }
    }
}
