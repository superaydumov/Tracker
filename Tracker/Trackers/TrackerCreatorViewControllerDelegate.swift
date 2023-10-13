//
//  TrackersCreatorViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

protocol TrackerCreatorViewControllerDelegate: AnyObject {
    func createTracker(tracker: Trackers, categoryName: String)
}
