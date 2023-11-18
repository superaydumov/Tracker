//
//  EventCreatorCollectionViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 16.10.2023.
//

import UIKit

final class EventCreatorCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "EventCreatorCollectionViewCell"
    
    // MARK: - Computed proprties
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 16
        
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(indexPath: IndexPath, emoji: String, color: UIColor) {
        
        if indexPath.section == 0 {
            self.emojiLabel.text = emoji
        } else if indexPath.section == 1 {
            self.colorView.backgroundColor = color
        }
    }
    
    func getCellText() -> String {
        guard let selectedText = self.emojiLabel.text else { return "" }
        
        return selectedText
    }
    
    func getCellColor() -> UIColor {
        self.layer.borderWidth = 3
        self.layer.borderColor = self.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        guard let selectedColor = self.colorView.backgroundColor else { return UIColor() }
        
        return selectedColor
    }
}
