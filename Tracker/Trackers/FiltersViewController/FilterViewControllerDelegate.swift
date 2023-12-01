//
//  FiltersViewControllerDelegate.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 01.12.2023.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func filterSelected(filter: Filters)
}
