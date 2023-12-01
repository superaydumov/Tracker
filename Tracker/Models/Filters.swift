//
//  Filters.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 01.12.2023.
//

import Foundation

enum Filters: String, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case inCompletedTrackers
    
    var localized: String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("allTrackers", comment: "")
        case .todayTrackers:
            return NSLocalizedString("todayTrackers", comment: "")
        case .completedTrackers:
            return NSLocalizedString("completedTrackers", comment: "")
        case .inCompletedTrackers:
            return NSLocalizedString("inCompletedTrackers", comment: "")
        }
    }
}
