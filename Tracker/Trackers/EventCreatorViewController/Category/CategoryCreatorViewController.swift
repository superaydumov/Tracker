//
//  CategoryCreatorViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 13.11.2023.
//

import UIKit

enum CategoryEvent {
    case creation
    case editing
    
    var titleText: String {
        switch self {
        case .creation:
            return NSLocalizedString("newCategory", comment: "")
        case .editing:
            return NSLocalizedString("editCategory", comment: "")
        }
    }
}

final class CategoryCreatorViewController: UIViewController {
    
    var editableCategory: TrackerCategory?
    weak var delegate: CategoryCreatorViewControllerDelegate?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private var viewModel: CategoryViewModel?
    private let categoryEvent: CategoryEvent
    
    private let textFieldPlaceholderText = NSLocalizedString("categoryTextFieldPlaceholder", comment: "CategoryCreatorVC textField placeholder text")
    private let performButtonText = NSLocalizedString("categoryPerformButton", comment: "CategoryCreatorVC performButton text")
    
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = categoryEvent.titleText
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = textFieldPlaceholderText
        textField.textColor = .trackerBlack
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.indentSize(leftSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var performButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(performButtonText, for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(performButtonDidTap(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(categoryEvent: CategoryEvent) {
        self.categoryEvent = categoryEvent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        self.hideKeyboardWhenTappedAround()
        
        addSubViews()
        constraintsSetup()
        
        if categoryEvent == .editing {
            textField.text = editableCategory?.categoryName
        }
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
        if categoryEvent == .creation {
            guard let name = textField.text else { return }
            let category = TrackerCategory(categoryName: name, trackers: [])
            try? trackerCategoryStore.addNewTrackerCategory(category)
            delegate?.createdCategory(category)
        } else if categoryEvent == .editing {
            guard let editableCategory else { return }
            if let newName = textField.text {
                try? trackerCategoryStore.updateTrackerCategory(newName, editableCategory)
            }
            NotificationCenter.default.post(name: NSNotification.Name("reloadCollectionView"), object: nil)
        }
        dismiss(animated: true)
    }
}
