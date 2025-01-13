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
    
    
    // MARK: - CollectionView Buttons Logic

    public func saveCellPosition(positions: [IndexPath: Int]) {
        resetCellPosition()
        for (indexPath, buttonID) in positions {
            guard let entity = NSEntityDescription.entity(forEntityName: "CellPosition", in: context) else { return }
            let cellPosition = NSManagedObject(entity: entity, insertInto: context)
            cellPosition.setValue(buttonID, forKey: "id")
            cellPosition.setValue(indexPath.row, forKey: "position")
        }
        appDelegate.saveContext()
    }

    public func loadCellPosition() -> [Int] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CellPosition")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            return results?.compactMap { $0.value(forKey: "id") as? Int } ?? []
        } catch {
            print("Failed to fetch cell positions: \(error)")
            return []
        }
    }

    public func resetCellPosition() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CellPosition")
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { context.delete($0) }
            appDelegate.saveContext()
        } catch {
            print("Failed to reset cell positions: \(error)")
        }
    }
    
    
    //MARK: - History Logic
    
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
    
    
    //MARK: - Keep Standard Data Logic
    
    public func saveStandardState(workings: String, results: String, isTypingNumber: Bool, firstOperand: Double?, currentOperation: Int?) {
        resetStandardState()
        guard let entity = NSEntityDescription.entity(forEntityName: "StandardState", in: context) else { return }
        let state = NSManagedObject(entity: entity, insertInto: context)
        
        state.setValue(workings, forKey: "workingsText")
        state.setValue(results, forKey: "resultsText")
        state.setValue(isTypingNumber, forKey: "isTypingNumber")
        state.setValue(firstOperand, forKey: "firstOperand")
        state.setValue(currentOperation, forKey: "currentOperation")
        
        appDelegate.saveContext()
        print("Standard state saved.")
    }
    
    public func loadStandardState() -> StandardState? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StandardState")
        do {
            let results = try context.fetch(fetchRequest) as? [StandardState]
            return results?.first
        } catch {
            print("Failed to load standard state: \(error)")
            return nil
        }
    }
    
    public func resetStandardState() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StandardState")
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { context.delete($0) }
            appDelegate.saveContext()
            print("Standard state reset.")
        } catch {
            print("Failed to reset standard state: \(error)")
        }
    }
    
}
