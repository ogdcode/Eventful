//
//  Event+CoreDataProperties.swift
//  EventFul
//
//  Created by Tracy Sablon on 09/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event");
    }

    @NSManaged public var synopsis: String?
    @NSManaged public var title: String?
    @NSManaged public var isFavorited: Bool

}
