//
//  HistoryItem+CoreDataProperties.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 12.09.2024.
//
//

import Foundation
import CoreData

public class HistoryItem: NSManagedObject {
    
}

extension HistoryItem {
    
    @NSManaged public var id: Int16
    @NSManaged public var date: Date?
    @NSManaged public var result: String?
    @NSManaged public var working: String?
    
}

extension HistoryItem : Identifiable { }
