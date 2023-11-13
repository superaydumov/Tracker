//
//  CategoryCreatorViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.11.2023.
//

import UIKit

final class CategoryCreatorViewController: UIViewController {
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = "Новая категория"
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.textColor = .trackerBlack
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.indentSize(leftSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var performButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(performButtonDidTap(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        self.hideKeyboardWhenTappedAround()
        
        addSubViews()
        constraintsSetup()
    }
    
    private func addSubViews() {
        view.addSubview(topLabel)
        view.addSubview(textField)
        view.addSubview(performButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            performButton.heightAnchor.constraint(equalToConstant: 60),
            performButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            performButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            performButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func textFieldDidChange(sender: AnyObject) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            performButton.backgroundColor = .trackerGray
            performButton.isEnabled = false
        } else {
            performButton.backgroundColor = .trackerBlack
            performButton.isEnabled = true
        }
    }
    
    @objc private func performButtonDidTap(sender: AnyObject) {
        guard let name = textField.text else { return }
        let category = TrackerCategory(categoryName: name, trackers: [])
        try? trackerCategoryStore.addNewTrackerCategory(category)
        
        dismiss(animated: true)
    }
}
