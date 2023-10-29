//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
