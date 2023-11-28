//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 28.11.2023.
//

import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func store(_ store: TrackerStore, didUpdate update: StoreUpdate)
}
