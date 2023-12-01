//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 01.12.2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private let filtersTopLabel = NSLocalizedString("filtersTopLabel", comment: "FiltersVC topLabel text")
    
    private let filters: [Filters] = Filters.allCases
    var selectedFilter: Filters?
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = filtersTopLabel
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.separatorColor = .trackerGray
        tableView.alwaysBounceVertical = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        addSubViews()
        constraintsSetup()
        
    }
    
    // MARK: - Private methods
    
    private func addSubViews() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
    }
    
    private func constraintsSetup() {
        let tableViewHeight = CGFloat (Filters.allCases.count * 75)
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTableViewCell.reuseIdentifier) as? FiltersTableViewCell else { return UITableViewCell() }
        
        let filterName = filters[indexPath.row].localized
        let checkProperty = indexPath.row == filters.count - 1
        let status = filterName != selectedFilter?.localized
        
        cell.configureCell(filterRawValue: filterName, checkProperty: checkProperty, checkMarkStatus: status)
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell else { return }
        
        let checkProperty = false
        cell.checkMarkSetup(checkMarkProperty: checkProperty)
        
        let filter = filters[indexPath.row]
        delegate?.filterSelected(filter: filter)
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell else { return }
        
        let checkProperty = true
        cell.checkMarkSetup(checkMarkProperty: checkProperty)
    }
}
