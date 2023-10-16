//
//  Date+Extension.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

extension Date {
    var yearMonthDayComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}
