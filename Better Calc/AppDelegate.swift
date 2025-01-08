//
//  AppDelegate.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 31.07.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var hasPerformedSegue = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    

    // MARK: - Core Data

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Better_Calc")
        container.loadPersistentStores{ (description, error) in
            if let error {
                print(error.localizedDescription)
            } else {
                print("Data Base Url -", description.url!.absoluteString)
            }
        }
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

}

