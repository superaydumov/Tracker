//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 12.11.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
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
    
    override func prepareForReuse() {
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = []
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
    
    func configureCell(categoryName: String, checkMarkIsHidden: Bool, startIndexCheck: Bool, endIndexCheck: Bool) {
        self.cellLabel.text = categoryName
        self.cellCheckMark.isHidden = checkMarkIsHidden
        
        if endIndexCheck {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            self.layer.cornerRadius = 16
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if startIndexCheck {
            self.layer.cornerRadius = 16
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func checkMarkSetup(checkProperty: Bool) {
        self.cellCheckMark.isHidden = checkProperty
    }
    
    func getCelltext() -> String {
        guard let selectedText = self.cellLabel.text else { return "" }
        
        return selectedText
    }
}
