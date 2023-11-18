//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 09.10.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private struct Keys {
        static let topLabel = "Расписание"
        static let performButton = "Готово"
    }
    
    weak var delegate: ScheduleViewControllerDelegate?
    var schedule = [WeekDay]()
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = Keys.topLabel
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .trackerWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(550))
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        var width = view.frame.width - 16 * 2
        var height = 7 * 75
        tableView.frame = CGRect(x: 16, y: 0, width: Int(width), height: Int(height))
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .trackerGray
        tableView.alwaysBounceVertical = true
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var performButton: UIButton = {
        let performButton = UIButton(type: .system)
        performButton.setTitle(Keys.performButton, for: .normal)
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
        
        updatePerformButton()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(topLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(tableView)
        view.addSubview(performButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: performButton.topAnchor),
            
            performButton.heightAnchor.constraint(equalToConstant: 60),
            performButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            performButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            performButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func updatePerformButton() {
        if schedule.isEmpty {
            performButton.isEnabled = false
            performButton.backgroundColor = .trackerGray
        } else {
            performButton.isEnabled = true
            performButton.backgroundColor = .trackerBlack
        }
    }
    
    // MARK: - Obj-C methods
    
    @objc private func performButtonDidTap(sender: AnyObject) {
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
        
        cell.delegate = self
        
        let dayRawValue = WeekDay.allCases[indexPath.row].rawValue
        let weekDay = WeekDay.allCases[indexPath.row]
        let scheduleDay = schedule.contains(weekDay)
        let checkProperty = indexPath.row == WeekDay.allCases.count - 1
        
        cell.configureCell(checkProperty: checkProperty,
                           dayRawValue: dayRawValue,
                           weekDay: weekDay,
                           scheduleDay: scheduleDay)
        
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
        
        updatePerformButton()
        
        let dayDictionary: [WeekDay: Int] = [.monday: 1, .tuesday: 2, .wednesday: 3, .thursday: 4, .friday: 5, .saturday: 6, .sunday: 7]
        schedule.sort { (dayDictionary[$0] ?? 7) < (dayDictionary[$1] ?? 7)}
    }
}
