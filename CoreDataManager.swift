//
//  StorageManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 12.09.2024.
//

import UIKit
import CoreData
import Foundation

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createHistoryObject(_ id: Int16, date: Date, result: String, working: String) {
        guard let objectEntityDescription = NSEntityDescription.entity(forEntityName: "HistoryItem", in: context) else { return }
        let object = HistoryItem(entity: objectEntityDescription, insertInto: context)
        object.id = id
        object.date = date
        object.result = result
        object.working = working
        
        appDelegate.saveContext()
    }
    
    public func fetchObjects(with id: Int16) -> [HistoryItem] {
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return (try context.fetch(fetchRequest) as? [HistoryItem]) ?? []
        } catch {
            print("Failed to fetch data for id: \(id)")
            return []
        }
    }
    
    public func fetchObject(with id: Int16) -> HistoryItem? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
         do {
             let objects = try? context.fetch(fetchRequest) as? [HistoryItem]
             return objects?.first
         }
    }
    
    public func updateObject(with id: Int16, result: String, working: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let objects = try? context.fetch(fetchRequest) as? [HistoryItem],
                  let object = objects.first else { return }
            object.result = result
            object.working = working
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllObjects(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try? context.fetch(fetchRequest) as? [HistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    public func deleteObject(object: NSManagedObject) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            print("Failed to delete object directly: \(error)")
        }

    }
    
    public func deleteAllHistory() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryItem")
        do {
            let objects = try? context.fetch(fetchRequest) as? [HistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    
}
