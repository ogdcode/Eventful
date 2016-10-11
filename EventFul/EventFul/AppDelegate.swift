//
//  AppDelegate.swift
//  EventFul
//
//  Created by Tracy Sablon on 28/09/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?                           // The application window.
    var dataManager : NSManagedObjectContext?       // The object managing the CoreData file.

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        dataManager = DataManager().context
        return true
    }
}

