//
//  TrackerCreatorViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 08.10.2023.
//

import UIKit

final class TrackerCreatorViewController: UIViewController {
    
    weak var delegate: TrackerCreatorViewControllerDelegate?
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Создание трекера"
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton(type: .system)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.trackerWhite, for: .normal)
        habitButton.backgroundColor = .trackerBlack
        habitButton.layer.cornerRadius = 16
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.addTarget(self, action: #selector(habitButtonDidTap(sender:)), for: .touchUpInside)
        
        return habitButton
    }()
    
    private lazy var nonRegularButton: UIButton = {
        let nonRegularButton = UIButton(type: .system)
        nonRegularButton.setTitle("Нерегулярное событие", for: .normal)
        nonRegularButton.setTitleColor(.trackerWhite, for: .normal)
        nonRegularButton.backgroundColor = .trackerBlack
        nonRegularButton.layer.cornerRadius = 16
        nonRegularButton.translatesAutoresizingMaskIntoConstraints = false
        nonRegularButton.addTarget(self, action: #selector(nonRegularButtonDidTap(sender:)), for: .touchUpInside)
        
        return nonRegularButton
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
        view.addSubview(habitButton)
        view.addSubview(nonRegularButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 295),
            
            nonRegularButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            nonRegularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            nonRegularButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            nonRegularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
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
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
