//
//  TrackerRecordStoreDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 30.11.2023.
//

import Foundation

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: StoreUpdate)
}
