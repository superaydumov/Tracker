//
//  TrackerStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerStore {
    
    static let shared = TrackerStore()
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(_ tracker: Trackers) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule?.compactMap { $0.rawValue }
        trackerCoreData.color = tracker.color.hexString
        
        try context.save()
    }
    
    func tracker(from data: TrackerCoreData) throws -> Trackers {
        guard
            let name = data.name,
            let id = data.id,
            let emoji = data.emoji,
            let color = data.color,
            let schedule = data.schedule
        else { throw DatabaseError.databaseError }
        
        return Trackers(
            id: id,
            name: name,
            color: color.color,
            emoji: emoji,
            schedule: schedule.compactMap { WeekDay(rawValue: $0) }
        )
    }
    
    func fetchTrackers() throws -> [Trackers] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackersFromCoreData = try context.fetch(fetchRequest)
        
        return try trackersFromCoreData.map { try self.tracker(from: $0) }
    }
}
