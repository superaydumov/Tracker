//
//  TrackerCategoryStoreDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 03.11.2023.
//

import Foundation

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, didUpdate update: StoreUpdate)
}
