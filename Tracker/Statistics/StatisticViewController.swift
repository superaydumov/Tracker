//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 06.10.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        navBarSetup()
        addSubViews()
        constraintsSetup()
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
            plugLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
