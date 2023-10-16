//
//  TrackersCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.10.2023.
//

import Foundation

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func completedTrackers(id: UUID)
}
