//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 11.10.2023.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Stored proprties
    
    static let cellIdentifier = "trackerCell"
    private var trackerID: UUID? = nil
    private var isCompletedToday: Bool = false
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    // MARK: - Computed proprties
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerWhite
        label.numberOfLines = 2
        label.text = "Название трекера"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(checckButtonDidTap(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        contentView.addSubview(colorView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(checkButton)
        
        colorView.addSubview(emojiView)
        colorView.addSubview(nameLabel)
        emojiView.addSubview(emojiLabel)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            checkButton.heightAnchor.constraint(equalToConstant: 34),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
            checkButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -8),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Public methods
    
    func configureCell(id: UUID,
                       name: String,
                       color: UIColor,
                       emoji: String,
                       isCompleted: Bool,
                       isEnabled: Bool,
                       completedCount: Int) {
        trackerID = id
        nameLabel.text = name
        colorView.backgroundColor = color
        emojiLabel.text = emoji
        isCompletedToday = isCompleted
        checkButton.setImage(isCompletedToday ? UIImage(systemName: "checkmark")! : UIImage(systemName: "plus")!, for: .normal)
        checkButton.isEnabled = isEnabled
        
        let dividedBy10 = completedCount % 10
        let dividedBy100 = completedCount % 100
        let notFrom10To20 = dividedBy100 < 10 || dividedBy100 > 20
        var daysString = "\(completedCount) "
        
        if completedCount == 0 {
            daysString += "дней"
        } else if dividedBy10 == 1 && notFrom10To20 {
            daysString += "день"
        } else if (dividedBy10 == 2 || dividedBy10 == 3 || dividedBy10 == 4) && notFrom10To20 {
            daysString += "дня"
        } else {
            daysString += "дней"
        }
        
        daysLabel.text = daysString
    }
    
    // MARK: - Objc methods
    
    @objc func checckButtonDidTap(sender: AnyObject) {
        guard let id = trackerID else {
            print("ID didn't set!")
            return }
        
        delegate?.completedTrackers(id: id)
    }
}