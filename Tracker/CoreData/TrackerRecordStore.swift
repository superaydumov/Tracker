//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject {
    
    static let shared = TrackerRecordStore()

    private let context: NSManagedObjectContext
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<StoreUpdate.Move>?
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    var trackerRecords: [TrackerRecord] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let trackerRecords = try? objects.map ({
                  try self.trackerRecord(from: $0)
              })
        else { return [] }
        
        return trackerRecords
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
    
    func deleteAllRecords(with id: UUID) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let trackerRecords = try context.fetch(fetchRequest)
        
        for record in trackerRecords {
            context.delete(record)
        }
        
        try context.save()
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

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<StoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes,
            let updatedIndexes,
            let movedIndexes
        else { return }
        
        delegate?.store(
            self,
            didUpdate: StoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath else { return }
            deletedIndexes?.insert(indexPath.item)
        case.insert:
            guard let indexPath = newIndexPath else { return }
            insertedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath else { return }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        default:
            break
        }
    }
}
