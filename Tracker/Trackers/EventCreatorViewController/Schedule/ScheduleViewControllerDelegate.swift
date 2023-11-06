//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.10.2023.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func createSchedule(schedule: [WeekDay])
}
