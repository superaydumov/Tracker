//
//  EventCreatorViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

protocol EventCreatorViewControllerDelegate: AnyObject {
    func createTracker(tracker: Trackers, categoryName: String)
}
