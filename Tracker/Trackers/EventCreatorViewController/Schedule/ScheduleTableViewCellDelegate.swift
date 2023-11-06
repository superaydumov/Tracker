//
//  ScheduleTableViewCellDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.10.2023.
//

import Foundation


protocol ScheduleTableViewCellDelegate: AnyObject {
    func switchStateChanged(for day: WeekDay, isOn: Bool)
}
