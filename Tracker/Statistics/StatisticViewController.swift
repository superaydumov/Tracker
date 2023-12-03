//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 06.10.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore.shared
    private var completedTrackers = [TrackerRecord]()
    
    private let statisticsHeaderText = NSLocalizedString("statisticsHeader", comment: "NavBar statistics label")
    private let plugLabelText = NSLocalizedString("statisticsPlugLabel", comment: "Statistics plugLabel text")
    
    // MARK: - Computed properties
    
    private lazy var plugView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var plugImageView: UIImageView = {
        let plugImageView = UIImageView()
        plugImageView.image = UIImage(named: "statisticPlugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return plugImageView
    }()
    
    private lazy var plugLabel: UILabel = {
       let plugLabel = UILabel()
        plugLabel.textColor = .trackerBlack
        plugLabel.text = plugLabelText
        plugLabel.textAlignment = .center
        plugLabel.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return plugLabel
    }()
    
    private lazy var completedTrackersView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        navBarSetup()
        addSubViews()
        constraintsSetup()
        updateStatistics()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        completedTrackersView.addGradientBorder(colors: [.redGradient, .greenGradient, .blueGradient], width: 1)
        updateStatistics()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    private func navBarSetup() {
        if let navigationBar = navigationController?.navigationBar {
            title = statisticsHeaderText
            navigationBar.prefersLargeTitles = true
        }
    }
    
    private func addSubViews() {
        view.addSubview(plugView)
        plugView.addSubview(plugImageView)
        plugView.addSubview(plugLabel)
        
        view.addSubview(completedTrackersView)
        completedTrackersView.addSubview(daysLabel)
        completedTrackersView.addSubview(subLabel)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            plugView.heightAnchor.constraint(equalToConstant: 110),
            plugView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            plugView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            plugView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugImageView.widthAnchor.constraint(equalToConstant: 80),
            plugImageView.heightAnchor.constraint(equalToConstant: 80),
            plugImageView.topAnchor.constraint(equalTo: plugView.topAnchor),
            plugImageView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.leadingAnchor.constraint(equalTo: plugView.leadingAnchor, constant: 16),
            plugLabel.trailingAnchor.constraint(equalTo: plugView.trailingAnchor, constant: -16),
            plugLabel.heightAnchor.constraint(equalToConstant: 18),
            
            completedTrackersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            completedTrackersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completedTrackersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completedTrackersView.heightAnchor.constraint(equalToConstant: 90),
            
            daysLabel.topAnchor.constraint(equalTo:  completedTrackersView.topAnchor, constant: 12),
            daysLabel.leadingAnchor.constraint(equalTo:  completedTrackersView.leadingAnchor, constant: 12),
            daysLabel.trailingAnchor.constraint(equalTo:  completedTrackersView.trailingAnchor, constant: -12),
            
            subLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor),
            subLabel.leadingAnchor.constraint(equalTo: daysLabel.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: daysLabel.trailingAnchor)
        ])
    }
    
    private func updateStatistics() {
        completedTrackers = trackerRecordStore.trackerRecords
        daysLabel.text = "\(completedTrackers.count)"
        subLabel.text = String.localizedStringWithFormat(NSLocalizedString("completeTrackers", comment: ""), completedTrackers.count)
        plugView.isHidden = completedTrackers.count > .zero
        completedTrackersView.isHidden = completedTrackers.count == .zero
    }
}

    // MARK: - TrackerRecordStoreDelegate

extension StatisticViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: StoreUpdate) {
        updateStatistics()
    }
}
