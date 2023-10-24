//
//  WeekDay.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.10.2023.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var numberOfDay: Int {
        switch self {

        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }
    
    var shortName: String {
        switch self {
            
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}

extension WeekDay: Comparable {
    static func <(lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.numberOfDay < rhs.numberOfDay
    }
    
    static func ==(lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.numberOfDay == rhs.numberOfDay
    }
}
