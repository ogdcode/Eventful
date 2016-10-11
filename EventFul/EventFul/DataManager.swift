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
    
    var context: NSManagedObjectContext        // The context of the object model(s).
    var resourceName: String = "EventFul"      // The name of the project file.
    
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
}
