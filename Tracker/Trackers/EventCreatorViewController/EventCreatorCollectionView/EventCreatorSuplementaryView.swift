//
//  EventCreatorSuplementaryView.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 16.10.2023.
//

import UIKit

final class EventCreatorSuplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "header"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
