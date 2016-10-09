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
    
    var context : NSManagedObjectContext
    
    override init() {
        
        guard let modelURL = Bundle.main.url(forResource: "EventFul", withExtension: "momd") else {
            fatalError("Erreur de chargement du modèle de donnée")
        }
        
        guard let modelSchema = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Erreur d'initialisation du model: \(modelURL)")
        }
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel:modelSchema)
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("documentURL: \(documentURL)")
        
        let dbURL = documentURL.appendingPathComponent("EventFulDB.db")
        
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
            let objectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            objectContext.persistentStoreCoordinator = storeCoordinator
            self.context = objectContext
        }
        catch {
            fatalError("Erreur d'association du store: \(error)")
        }
        
        
    }

    
    /*func createNewEvent(titre:String, eventDetail:String, context:NSManagedObjectContext){
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
        
        event.titre = titre
        event.eventDetail = eventDetail
        
    }*/

}
