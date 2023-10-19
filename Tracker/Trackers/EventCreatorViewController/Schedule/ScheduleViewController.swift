//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 09.10.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private var schedule = [WeekDay]()
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = "Расписание"
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        var width = view.frame.width - 16 * 2
        var height = 7 * 75
        tableView.frame = CGRect(x: 16, y: 78, width: Int(width), height: Int(height))
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .trackerGray
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var performButton: UIButton = {
        let performButton = UIButton(type: .system)
        performButton.setTitle("Готово", for: .normal)
        performButton.setTitleColor(.trackerWhite, for: .normal)
        performButton.backgroundColor = .trackerGray
        performButton.layer.cornerRadius = 16
        performButton.addTarget(self, action: #selector(performButtonDidTap(sender:)), for: .touchUpInside)
        performButton.translatesAutoresizingMaskIntoConstraints = false
        
        return performButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        addSubviews()
        constraintsSetup()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        view.addSubview(performButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            performButton.heightAnchor.constraint(equalToConstant: 60),
            performButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            performButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            performButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Obj-C methods
    
    @objc func performButtonDidTap(sender: AnyObject) {
        delegate?.createSchedule(schedule: schedule)
        dismiss(animated: true)
    }
}

    // MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        cell.contentView.backgroundColor = .trackerBackground
        cell.selectionStyle = .none
        cell.cellLabel.text = WeekDay.allCases[indexPath.row].rawValue
        cell.weekDay = WeekDay.allCases[indexPath.row]
        cell.delegate = self
        
        if indexPath.row == 6 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

    // MARK: - ScheduleTableViewCellDelegate

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func switchStateChanged(for day: WeekDay, isOn: Bool) {
        if isOn {
            schedule.append(day)
        } else {
            if let index = schedule.firstIndex(of: day) {
                schedule.remove(at: index)
            }
        }
        
        if schedule.isEmpty {
            performButton.isEnabled = false
            performButton.backgroundColor = .trackerGray
        } else {
            performButton.isEnabled = true
            performButton.backgroundColor = .trackerBlack
        }
        
        let dayDictionary: [WeekDay: Int] = [.monday: 1, .tuesday: 2, .wednesday: 3, .thursday: 4, .friday: 5, .saturday: 6, .sunday: 7]
        schedule.sort { (dayDictionary[$0] ?? 7) < (dayDictionary[$1] ?? 7)}
    }
}
