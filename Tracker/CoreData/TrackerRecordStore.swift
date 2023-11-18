//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    
    static let shared = TrackerRecordStore()
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        
        trackerRecordCoreData.id = trackerRecord.trackerID
        trackerRecordCoreData.date = trackerRecord.date
        
        try context.save()
    }
    
    func deleteTrackerRecord(with id: UUID) throws {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        let record = trackerRecordFromCoreData.first {
            $0.id == id
        }
        if let record = record {
            context.delete(record)
            try context.save()
        }
    }
    
    func trackerRecord(from data: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = data.id,
            let date = data.date
        else { throw DatabaseError.databaseError }
        
        return TrackerRecord(
            trackerID: id,
            date: date
        )
    }
    
    func fetchTrackers() throws -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        
        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
    }
}
