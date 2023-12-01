//
//  TrackerCreatorViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 08.10.2023.
//

import UIKit

final class TrackerCreatorViewController: UIViewController {
    
    private let topLabelText = NSLocalizedString("topLabel", comment: "TrackerCreator topLabel text")
    private let habitButtonTitleText = NSLocalizedString("habitButtonTitle", comment: "TrackerCreator habitButtonTitle text")
    private let nonRegularButtonTitleText = NSLocalizedString("nonRegularButtonTitle", comment: "TrackerCreator nonRegularButtonTitle text")
    
    weak var delegate: TrackerCreatorViewControllerDelegate?
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = topLabelText
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton(type: .system)
        habitButton.setTitle(habitButtonTitleText, for: .normal)
        habitButton.setTitleColor(.trackerWhite, for: .normal)
        habitButton.backgroundColor = .trackerBlack
        habitButton.layer.cornerRadius = 16
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.addTarget(self, action: #selector(habitButtonDidTap(sender:)), for: .touchUpInside)
        
        return habitButton
    }()
    
    private lazy var nonRegularButton: UIButton = {
        let nonRegularButton = UIButton(type: .system)
        nonRegularButton.setTitle(nonRegularButtonTitleText, for: .normal)
        nonRegularButton.setTitleColor(.trackerWhite, for: .normal)
        nonRegularButton.backgroundColor = .trackerBlack
        nonRegularButton.layer.cornerRadius = 16
        nonRegularButton.translatesAutoresizingMaskIntoConstraints = false
        nonRegularButton.addTarget(self, action: #selector(nonRegularButtonDidTap(sender:)), for: .touchUpInside)
        
        return nonRegularButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        addSubViews()
        constraintsSetup()
    }
    
    // MARK: - Private methods
    
    private func addSubViews() {
        view.addSubview(topLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(nonRegularButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            habitButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            habitButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            
            nonRegularButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            nonRegularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            nonRegularButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
        ])
    }
    
    // MARK: - Obj-C methods
    
    @objc func habitButtonDidTap(sender: AnyObject) {
        let eventCreator = EventCreatorViewController(event: .habit)
        eventCreator.delegate = self
        present(eventCreator, animated: true)
    }
    
    @objc func nonRegularButtonDidTap(sender: AnyObject) {
        let eventCreator = EventCreatorViewController(event: .nonRegular)
        eventCreator.delegate = self
        present(eventCreator, animated: true)
    }
}

extension TrackerCreatorViewController: EventCreatorViewControllerDelegate {
    func createTracker(tracker: Trackers, categoryName: String) {
        delegate?.createTracker(tracker: tracker, categoryName: categoryName)
    }
}
