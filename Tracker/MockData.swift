//
//  MockData.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

final class MockData {
    static var categories: [TrackerCategory] = [
        TrackerCategory(categoryName: "Развлечения",
                        trackers: [Trackers(id: UUID(),
                                            name: "Играть в прятки как ниндзя",
                                            color: .colorSelection2,
                                            emoji: "🥷🏻",
                                            schedule: [.monday, .wednesday, .saturday, .sunday]),
                                   Trackers(id: UUID(), name: "Стать самураем", color: .colorSelection12, emoji: "🐥", schedule: [.tuesday, .thursday, .friday])]),
        TrackerCategory(categoryName: "Радостные мелочи", trackers: [Trackers(id: UUID(), name: "Заказать покушац", color: .colorSelection18, emoji: "🍞", schedule: [.monday, .sunday])])
    ]
}
