//
//  TrackerStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<StoreUpdate.Move>?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
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
    
    func addNewTracker(_ tracker: Trackers) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule?.compactMap { $0.rawValue }
        trackerCoreData.color = tracker.color.hexString
        
        try context.save()
    }
    
    func togglePinTracker(_ tracker: Trackers) throws {
        let tracker = fetchedResultsController.fetchedObjects?.first {
            $0.id == tracker.id
        }
        tracker?.pinned = !(tracker?.pinned ?? false)
        
        try context.save()
    }
    
    func deleteTracker(_ trackerToDelete: Trackers) throws {
        let tracker = fetchedResultsController.fetchedObjects?.first {
            $0.id == trackerToDelete.id
        }
        if let tracker = tracker {
            context.delete(tracker)
            try context.save()
        }
    }
    
    func tracker(from data: TrackerCoreData) throws -> Trackers {
        guard
            let name = data.name,
            let id = data.id,
            let emoji = data.emoji,
            let color = data.color,
            let schedule = data.schedule
        else { throw DatabaseError.databaseError }
        let pinned = data.pinned
        
        return Trackers(
            id: id,
            name: name,
            color: color.color,
            emoji: emoji,
            schedule: schedule.compactMap { WeekDay(rawValue: $0) },
            pinned: pinned
        )
    }
    
    func fetchTrackers() throws -> [Trackers] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackersFromCoreData = try context.fetch(fetchRequest)
        
        return try trackersFromCoreData.map { try self.tracker(from: $0) }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
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
