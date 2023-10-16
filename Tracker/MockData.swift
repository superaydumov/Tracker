//
//  MockData.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

final class MockData {
    static var categories: [TrackerCategory] = [
        TrackerCategory(
            categoryName: "Развлечения",
            trackers: [
                Trackers(
                    id: UUID(),
                    name: "Играть в прятки как ниндзя",
                    color: .colorSelection2,
                    emoji: "🥷🏻",
                    schedule: [.monday, .wednesday, .friday]
                ),
                Trackers(
                    id: UUID(),
                    name: "Стать самураем",
                    color: .colorSelection12,
                    emoji: "🐥",
                    schedule: [.tuesday, .thursday, .saturday]
                )
            ]
        ),
        
        TrackerCategory(
            categoryName: "Радостные мелочи",
            trackers: [
                Trackers(
                    id: UUID(),
                    name: "Заказать покушац",
                    color: .colorSelection18,
                    emoji: "🍞",
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                ),
                Trackers(
                    id: UUID(),
                    name: "Посмотреть фильм",
                    color: .colorSelection12,
                    emoji: "📺",
                    schedule: [.saturday, .sunday]
                ),
                Trackers(
                    id: UUID(),
                    name: "Выпить кофе",
                    color: .colorSelection11,
                    emoji: "☕️",
                    schedule: [.monday, .tuesday, .thursday]
                )
            ]
        ),
        
        TrackerCategory(
            categoryName: "Важное",
            trackers: [
                Trackers(
                    id: UUID(),
                    name: "Принести хворост",
                    color: .colorSelection13,
                    emoji: "🪵",
                    schedule: [.tuesday, .wednesday, .friday]
                ),
                Trackers(
                    id: UUID(),
                    name: "Покормить белку",
                    color: .colorSelection14,
                    emoji: "🐿️",
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                ),
                Trackers(
                    id: UUID(),
                    name: "Разжечь костер",
                    color: .colorSelection14,
                    emoji: "🔥",
                    schedule: [.tuesday, .wednesday, .friday]
                )
            ]
        )
    ]
}
