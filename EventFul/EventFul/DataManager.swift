//
//  DataManager.swift
//  EventFul
//
//  Created by Tracy Sablon on 02/10/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    let resourceName: String! = "EventFul"      // The name of the project file.
    
    let eventEntity: String! = "Event"          // The name of the Event entity.
    
    // Event attribute
    let EVENT_TITLE: String! = "title"          // The name of the 'title'
    
    var context: NSManagedObjectContext?        // The context of the object model(s).
    
    override init() {
        
        guard let modelURL = Bundle.main.url(forResource: self.resourceName, withExtension: "momd") else {
            fatalError("Data model loading error")
        }
        
        guard let modelSchema = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Model initialization error: could not load \(modelURL)")
        }
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: modelSchema)
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let dbURL = documentURL.appendingPathComponent(self.resourceName + "DB.db")
        
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
            let objectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            objectContext.persistentStoreCoordinator = storeCoordinator
            self.context = objectContext
        }
        catch {
            fatalError("Store association error: \(error)")
        }
    }
    
    // MARK: - Event Storage
    
    func createEvent(_ title: String!, _ synopsis: String!) -> Bool! {
        let request = NSFetchRequest<Event>(entityName: self.eventEntity)
        request.predicate = NSPredicate(format: "%@ = %@", EVENT_TITLE, title)
        
        let events = try? (self.context?.fetch(request))!
        
        // if an event with that title already exists,
        // it must not be allowed to create a new one
        // with the same title
        if (events?.count)! > 0 {
            return false
        }
        
        let event = NSEntityDescription.insertNewObject(forEntityName: self.eventEntity, into: self.context!) as! Event
        event.title = title
        event.synopsis = synopsis
        
        self.save()

        return true
    }
    
    func readAllEvents() -> [Event]? {
        let request = NSFetchRequest<Event>(entityName: self.eventEntity)
        return try! self.context?.fetch(request)
    }
    
    // in CoreData, updating an object is as simple
    // as retreiving it and then locally editing it before saving
    func readOrUpdateEvent(_ event: Event!, _ predicate: NSPredicate) -> Event? {
        let request = NSFetchRequest<Event>(entityName: self.eventEntity)
        request.predicate = predicate
        
        let events: [Event] = try! (self.context?.fetch(request))!
        
        return events.first!
    }
    
    func deleteEvent(_ event: Event!, _ predicate: NSPredicate) -> Bool! {
        let evt: Event = self.readOrUpdateEvent(event, predicate)!
        self.context?.delete(evt)
        
        self.save()

        return false
    }
    
    func setEventFavorite(_ event: Event!, _ predicate: NSPredicate, _ isFav: Bool!) -> Bool! {
        let evt: Event = self.readOrUpdateEvent(event, predicate)!
        evt.isFavorited = isFav
        
        self.save()
        
        return false
    }
    
    // 'shortcut' function to save only when changes are made
    func save() {
        if (self.context?.hasChanges)! {
            self.save()
        }
    }
}
