//
//  EventTableViewCell.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!                // The event title.
    @IBOutlet weak var eventSynopsisLabel: UILabel!             // The event synopsis.

    @IBOutlet weak var editEventButton: UIButton!               // A button to validate edits made to the event.
    @IBOutlet weak var deleteEventButton: UIButton!             // A button to delete an event.
    @IBOutlet weak var addEventToFavoritesButton: UIButton!     // A button to change the favorite status of the event.
    
    // MARK: - UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set a label to the Add Event To Favorites button
        // so that actions can be easily targeted at it in the code
        // but hide it so it does not show up over its icon
        self.addEventToFavoritesButton.titleLabel?.text = "Favoris"
        self.addEventToFavoritesButton.titleLabel?.isHidden = true
    }
}
