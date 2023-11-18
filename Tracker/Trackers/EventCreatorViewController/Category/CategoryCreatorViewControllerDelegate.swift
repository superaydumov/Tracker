//
//  CategoryCreatorViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 16.11.2023.
//

import Foundation

protocol CategoryCreatorViewControllerDelegate: AnyObject {
    func createdCategory(_ category: TrackerCategory)
}
