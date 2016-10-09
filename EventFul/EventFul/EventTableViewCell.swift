//
//  EventTableViewCell.swift
//  EventFul
//
//  Created by Tracy Sablon on 03/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var titreTableViewCell: UILabel!
    
    @IBOutlet weak var modifierButton: UIButton!
    @IBOutlet weak var supprimerButton: UIButton!
    @IBOutlet weak var favorisButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favorisButton.titleLabel?.text = "Favoris"
        favorisButton.titleLabel?.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
