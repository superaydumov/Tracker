//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 15.11.2023.
//

import UIKit

final class CategoryViewModel: NSObject {
    
    var onChange: (() -> Void)?
    
    private(set) var categories = [TrackerCategory]() {
        didSet {
            onChange?()
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private(set) var selectedCategory: TrackerCategory?
    private weak var delegate: CategoryViewModelDelegate?
    
    init(selectedCategory: TrackerCategory?, delegate: CategoryViewModelDelegate?) {
        self.selectedCategory = selectedCategory
        self.delegate = delegate
        
        super.init()
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
    }
    
    func deleteTrackerCategory(_ category: TrackerCategory) {
        try? self.trackerCategoryStore.deleteTrackerCategory(category)
        category.trackers.forEach({ tracker in
            try? self.trackerRecordStore.deleteAllRecords(with: tracker.id)
        })
    }
    
    func selectCategory(with categoryName: String) {
        let category = TrackerCategory(categoryName: categoryName, trackers: [])
        delegate?.createCategory(category: category)
    }
    
    func selectedCategory(_ category: TrackerCategory) {
        selectedCategory = category
        onChange?()
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: StoreUpdate) {
        categories = trackerCategoryStore.trackerCategories
    }
}
