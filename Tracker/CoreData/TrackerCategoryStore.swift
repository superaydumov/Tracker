//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 29.10.2023.
//

import Foundation
import CoreData

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<StoreUpdate.Move>?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.category, ascending: true)
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
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackerCategories = try? objects.map({
                try self.trackerCategory(from: $0)
            }) else { return [] }
        
        return trackerCategories
    }
    
    func trackerCategory(from data: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let category = data.category else {
            throw DatabaseError.decodingError
        }
        
        let trackers: [Trackers] = data.trackers?.compactMap { tracker in
            guard let trackerCoreData = tracker as? TrackerCoreData else { return nil }
            
            guard
                let id = trackerCoreData.id,
                let name = trackerCoreData.name,
                let color = trackerCoreData.color?.color,
                let emoji = trackerCoreData.emoji
            else { return nil }
            let pinned = trackerCoreData.pinned

            return Trackers(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: trackerCoreData.schedule?.compactMap {
                    WeekDay(rawValue: $0) },
                pinned: pinned
            )
        } ?? []

        return TrackerCategory(
            categoryName: category,
            trackers: trackers
        )
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        trackerCategoryCoreData.category = trackerCategory.categoryName
        
        for tracker in trackerCategory.trackers {
            let property = TrackerCoreData(context: context)
            
            property.id = tracker.id
            property.name = tracker.name
            property.color = tracker.color.hexString
            property.emoji = tracker.emoji
            property.schedule = tracker.schedule?.compactMap { $0.rawValue }
            
            trackerCategoryCoreData.addToTrackers(property)
        }
        
        try context.save()
    }
    
    func updateTrackerCategory(_ newName: String, _ editableCategory: TrackerCategory) throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.category == editableCategory.categoryName
        }
        
        category?.category = newName
        try context.save()
    }
    
    func deleteTrackerCategory(_ deletedCategory: TrackerCategory) throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.category == deletedCategory.categoryName
        }
        
        if let category = category {
            context.delete(category)
            try context.save()
        }
    }
    
    func addTracker(_ tracker: Trackers, to trackerCategory: TrackerCategory) throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.category == trackerCategory.categoryName
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color.hexString
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule?.compactMap { $0.rawValue }
        
        category?.addToTrackers(trackerCoreData)
        try context.save()
    }
    
    func predicateFetch(trackerName: String) -> [TrackerCategory] {
        if trackerName.isEmpty {
            return trackerCategories
        } else {
            let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "ANY trackers.category CONTAINS[cd] %@", trackerName)
            guard let trackerCategoriesCoreData = try? context.fetch(request)
                else { return [] }
            guard let categories = try? trackerCategoriesCoreData.map ({ try self.trackerCategory(from: $0) })
                else { return [] }
            
            return categories
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
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
