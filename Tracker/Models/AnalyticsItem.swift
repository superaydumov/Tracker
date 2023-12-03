//
//  AnalyticsItem.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 03.12.2023.
//

import Foundation

enum AnalyticsItem: String, CaseIterable {
    case addTrack = "addTrack"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}
