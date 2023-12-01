//
//  FiltersTableViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 01.12.2023.
//

import UIKit

final class FiltersTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "FiltersTableViewCell"
    
    // MARK: - Computed Properties
    
    private lazy var cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.textColor = .trackerBlack
        cellLabel.font = .systemFont(ofSize: 17)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cellLabel
    }()
    
    private lazy var cellCheckMark: UIImageView = {
        let checkMark = UIImageView()
        checkMark.image = UIImage(systemName: "checkmark")
        checkMark.isHidden = true
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        
        return checkMark
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .trackerBackground
        self.selectionStyle = .none
        
        addSubviews()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        self.contentView.addSubview(cellLabel)
        self.contentView.addSubview(cellCheckMark)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cellCheckMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellCheckMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellCheckMark.heightAnchor.constraint(equalToConstant: 24),
            cellCheckMark.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Public methods
    
    func configureCell(filterRawValue: String, checkProperty: Bool, checkMarkStatus: Bool) {
        self.cellLabel.text = filterRawValue
        self.cellCheckMark.isHidden = checkMarkStatus
        
        if checkProperty {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func checkMarkSetup(checkMarkProperty: Bool) {
        self.cellCheckMark.isHidden = checkMarkProperty
    }
}
