//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.10.2023.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    weak var delegate: ScheduleTableViewCellDelegate?
    var weekDay: WeekDay?
    
    // MARK: - Computed properties
    
    private lazy var cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.textColor = .trackerBlack
        cellLabel.font = .systemFont(ofSize: 17)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return cellLabel
    }()
    
    private lazy var cellSwitch: UISwitch = {
        let cellSwitch = UISwitch()
        cellSwitch.onTintColor = .trackerBlue
        cellSwitch.addTarget(self, action: #selector(cellSwitchValueChanged(sender:)), for: .valueChanged)
        cellSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return cellSwitch
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .trackerBackground
        
        addSubviews()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        self.contentView.addSubview(cellLabel)
        self.contentView.addSubview(cellSwitch)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cellSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Public methods
    
    func configureCell(checkProperty: Bool, dayRawValue: String, weekDay: WeekDay, scheduleDay: Bool) {
        self.cellLabel.text = dayRawValue
        self.weekDay = weekDay
        self.cellSwitch.isOn = scheduleDay
        
        if checkProperty {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    // MARK: - Obj-C methods
    
    @objc func cellSwitchValueChanged(sender: UISwitch) {
        guard let weekDay else { return }
        delegate?.switchStateChanged(for: weekDay, isOn: sender.isOn)
    }
}
