//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 12.11.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    lazy var cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.textColor = .trackerBlack
        cellLabel.font = .systemFont(ofSize: 17)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cellLabel
    }()
    
    lazy var cellCheckMark: UIImageView = {
        let checkMark = UIImageView()
        checkMark.image = UIImage(systemName: "checkmark")
        checkMark.isHidden = true
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        
        return checkMark
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}
