//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 12.11.2023.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    func createCategory(category: TrackerCategory)
}
