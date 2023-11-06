//
//  TrckerCategory.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 11.10.2023.
//

import Foundation

struct TrackerCategory {
    let categoryName: String
    let trackers: [Trackers]
    
    func visibleTrackers(filterString: String) -> [Trackers] {
        if filterString.isEmpty {
            return trackers
        } else {
            return trackers.filter {
                $0.name.lowercased().contains(filterString.lowercased()) }
        }
    }
}
