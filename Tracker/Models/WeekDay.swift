//
//  WeekDay.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.10.2023.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var numberOfDay: Int {
        switch self {

        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayShort", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayShort", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayShort", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayShort", comment: "")
        case .friday:
            return NSLocalizedString("fridayShort", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayShort", comment: "")
        case .sunday:
            return NSLocalizedString("sundayShort", comment: "")
        }
    }
    
    var localized: String {
        switch self {
        case .monday:
            return NSLocalizedString("monday", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("thursday", comment: "")
        case .friday:
            return NSLocalizedString("friday", comment: "")
        case .saturday:
            return NSLocalizedString("saturday", comment: "")
        case .sunday:
            return NSLocalizedString("sunday", comment: "")
        }
    }
}
