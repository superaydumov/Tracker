//
//  AlertPresenterProtocol.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 15.11.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
