//
//  Trackers.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 11.10.2023.
//

import UIKit

struct Trackers {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
}
