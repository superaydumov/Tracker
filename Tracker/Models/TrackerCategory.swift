//
//  TrckerCategory.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 11.10.2023.
//

import Foundation

struct TrackerCategory: Hashable {
    let categoryName: String
    let trackers: [Trackers]
    
    func visibleTrackers(filterString: String, pinned: Bool?) -> [Trackers] {
        if filterString.isEmpty {
            return pinned == nil ? trackers : trackers.filter { $0.pinned == pinned }
        } else {
            return pinned == nil ? trackers.filter { $0.name.lowercased().contains(filterString.lowercased()) } :
            trackers
                .filter { $0.name.lowercased().contains(filterString.lowercased()) }
                .filter { $0.pinned == pinned }
        }
    }
}
