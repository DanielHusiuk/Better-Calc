//
//  StorageManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 12.09.2024.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func deleteHaptics() {
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    // MARK: - CollectionView Buttons
    
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
    
    
    //MARK: - Calculator History
    
    public func createCalculatorHistoryObject(_ id: Int64, date: Date, result: String, working: String) {
        guard let objectEntityDescription = NSEntityDescription.entity(forEntityName: "CalculatorHistoryItem", in: context) else { return }
        let object = CalculatorHistoryItem(entity: objectEntityDescription, insertInto: context)
        object.id = id
        object.date = date
        object.result = result
        object.working = working
        appDelegate.saveContext()
    }
    
    public func fetchCalculatorObjects(with id: Int64) -> [CalculatorHistoryItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return (try context.fetch(fetchRequest) as? [CalculatorHistoryItem]) ?? []
        } catch {
            print("Failed to fetch data for id: \(id)")
            return []
        }
    }
    
    public func fetchCalculatorObject(with id: Int64) -> CalculatorHistoryItem? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let objects = try? context.fetch(fetchRequest) as? [CalculatorHistoryItem]
            return objects?.first
        }
    }
    
    public func updateCalculatorObject(with id: Int64, result: String, working: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let objects = try? context.fetch(fetchRequest) as? [CalculatorHistoryItem],
                  let object = objects.first else { return }
            object.result = result
            object.working = working
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllCalculatorObjects(with id: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try? context.fetch(fetchRequest) as? [CalculatorHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    public func deleteCalculatorObject(object: NSManagedObject) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            print("Failed to delete object directly: \(error)")
        }
        deleteHaptics()
    }
    
    public func deleteCalculatorObjectDate(with date: Date, value: Int) {
        guard !value.description.isEmpty, value != 0 else { print("core data date value is empty"); return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        guard let cutoffDate = Calendar.current.date(byAdding: .day, value: value, to: date) else { return }
        fetchRequest.predicate = NSPredicate(format: "date < %@", cutoffDate as NSDate)
        do {
            let objects = try? context.fetch(fetchRequest) as? [CalculatorHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    public func deleteAllCalculatorHistory() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculatorHistoryItem")
        do {
            let objects = try? context.fetch(fetchRequest) as? [CalculatorHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    
    //MARK: - Converter History
    
    public func createConverterHistoryObject(_ id: Int64, date: Date, fromText: String, fromUnit: Int64, fromUnitText: String, toText: String, toUnit: Int64, toUnitText: String) {
        guard let objectEntityDescription = NSEntityDescription.entity(forEntityName: "ConverterHistoryItem", in: context) else { return }
        let object = ConverterHistoryItem(entity: objectEntityDescription, insertInto: context)
        object.id = id
        object.date = date
        
        object.fromText = fromText
        object.fromUnit = fromUnit
        object.fromUnitText = fromUnitText
        
        object.toText = toText
        object.toUnit = toUnit
        object.toUnitText = toUnitText
        
        print("Converter history created.")
        appDelegate.saveContext()
    }
    
    public func fetchConverterObjects(with id: Int64) -> [ConverterHistoryItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            print("Converter histories fetched.")
            return (try context.fetch(fetchRequest) as? [ConverterHistoryItem]) ?? []
        } catch {
            print("Failed to fetch data for id: \(id)")
            return []
        }
    }
    
    public func fetchConverterObject(with id: Int64) -> ConverterHistoryItem? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let objects = try? context.fetch(fetchRequest) as? [ConverterHistoryItem]
            print("Converter history fetched.")
            return objects?.first
        }
    }
    
    public func updateConverterObject(with id: Int64, date: Date, fromText: String, fromUnit: Int64, fromUnitText: String, toText: String, toUnit: Int64, toUnitText: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let objects = try? context.fetch(fetchRequest) as? [ConverterHistoryItem],
                  let object = objects.first else { return }
            object.fromText = fromText
            object.fromUnit = fromUnit
            object.fromUnitText = fromUnitText
            
            object.toText = toText
            object.toUnit = toUnit
            object.toUnitText = toUnitText
        }
        print("Converter history updated.")
        appDelegate.saveContext()
    }
    
    public func deleteAllConverterObjects(with id: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try? context.fetch(fetchRequest) as? [ConverterHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    public func deleteConverterObject(object: NSManagedObject) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            print("Failed to delete object directly: \(error)")
        }
        deleteHaptics()
    }
    
    public func deleteConverterObjectDate(with date: Date, value: Int) {
        guard !value.description.isEmpty, value != 0 else { print("converter core data date value is empty"); return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        guard let cutoffDate = Calendar.current.date(byAdding: .day, value: value, to: date) else { return }
        fetchRequest.predicate = NSPredicate(format: "date < %@", cutoffDate as NSDate)
        do {
            let objects = try? context.fetch(fetchRequest) as? [ConverterHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    public func deleteAllConverterHistory() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterHistoryItem")
        do {
            let objects = try? context.fetch(fetchRequest) as? [ConverterHistoryItem]
            objects?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
        deleteHaptics()
    }
    
    
    //MARK: - Calculator State
    
    public func saveBasicState(workings: String, results: String, isTypingNumber: Bool, firstOperand: Double?, currentOperation: Int?) {
        resetBasicState()
        guard let entity = NSEntityDescription.entity(forEntityName: "BasicState", in: context) else { return }
        let state = NSManagedObject(entity: entity, insertInto: context)
        
        state.setValue(workings, forKey: "workingsText")
        state.setValue(results, forKey: "resultsText")
        state.setValue(isTypingNumber, forKey: "isTypingNumber")
        state.setValue(firstOperand, forKey: "firstOperand")
        state.setValue(currentOperation, forKey: "currentOperation")
        appDelegate.saveContext()
        print("Standard state saved.")
    }
    
    public func loadBasicState() -> BasicState? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BasicState")
        do {
            let results = try context.fetch(fetchRequest) as? [BasicState]
            return results?.first
        } catch {
            print("Failed to load standard state: \(error)")
            return nil
        }
    }
    
    public func resetBasicState() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BasicState")
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { context.delete($0) }
            appDelegate.saveContext()
            print("Standard state reset.")
        } catch {
            print("Failed to reset converter state: \(error)")
        }
    }
    
    
    //MARK: - Converter State
    
    public func saveConverterState(id: Int64, fromText: String, toText: String, fromUnit: Int64, toUnit: Int64) {
        resetConverterState(with: id)
        guard let entity = NSEntityDescription.entity(forEntityName: "ConverterState", in: context) else { return }
        let state = ConverterState(entity: entity, insertInto: context)
        
        state.id = id
        state.fromText = fromText
        state.toText = toText
        state.fromUnit = fromUnit
        state.toUnit = toUnit
        appDelegate.saveContext()
        print("Converter state saved.")
    }
    
    public func loadConverterState(with id: Int64) -> ConverterState? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterState")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest) as? [ConverterState]
            return results?.first
        } catch {
            print("Failed to load converter state: \(error)")
            return nil
        }
    }
    
    public func resetConverterState(with id: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverterState")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { context.delete($0) }
            appDelegate.saveContext()
            print("Converter state reset.")
        } catch {
            print("Failed to reset converter state: \(error)")
        }
    }
    
}
