//
//  AlertModel.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 14.11.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let firstButtonText: String
    let secondButtontext: String
    let firstCompletion: () -> Void
}
