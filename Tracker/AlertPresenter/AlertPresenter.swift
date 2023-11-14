//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 15.11.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: model.firstButtonText, style: .destructive) { _ in
            model.firstCompletion()
        }
        let secondAction = UIAlertAction(title: model.secondButtontext, style: .cancel)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        
        alert.view.accessibilityIdentifier = "alert"
        
        delegate?.present(alert, animated: true)
    }
}
