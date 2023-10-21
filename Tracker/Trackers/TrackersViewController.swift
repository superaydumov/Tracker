//
//  ViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 30.09.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Stored proprties
    
    private var currentDate: Int?
    private var searchText: String = ""
    private var widthAnchor: NSLayoutConstraint?
    
    private var categories: [TrackerCategory] = MockData.categories
    private var visibleCategories = [TrackerCategory]()
    private var completedTrackers = [TrackerRecord]()
    
    // MARK: - Computed properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .trackerWhite
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.cellIdentifier)
        collectionView.register(TrackersCellSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersCellSuplementaryView.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        return formatter
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.layer.backgroundColor = UIColor.trackerBackground.cgColor
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(didTapDateButton(sender:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var plugImageView: UIImageView = {
        let plugImageView = UIImageView()
        plugImageView.image = UIImage(named: "trackersPlugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return plugImageView
    }()
    
    private lazy var plugLabel: UILabel = {
       let plugLabel = UILabel()
        plugLabel.textColor = .trackerBlack
        plugLabel.text = "Что будем отслеживать?"
        plugLabel.textAlignment = .center
        plugLabel.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return plugLabel
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.textColor = .trackerBlack
        searchTextField.font = .systemFont(ofSize: 17)
        searchTextField.backgroundColor = .trackerBackground
        searchTextField.layer.cornerRadius = 10
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textFieldDidChanged(sender:)), for: .editingChanged)
        searchTextField.delegate = self
        
        return searchTextField
    }()
    
    private lazy var cancelSearchTextFieldButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.trackerBlue, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap(sender:)), for: .touchUpInside)
        
        return cancelButton
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = false
        
        setWeekDay()
        updateCategories()
        navBarSetup()
        addSubViews()
        constraintsSetup()
        additionalConstraintsSetup()
    }
    
    // MARK: - Private methods
    
    private func navBarSetup() {
        if let navigationBar = navigationController?.navigationBar {
            title = "Трекеры"
            navigationBar.prefersLargeTitles = true
            
            let addTrackerButton = UIBarButtonItem(image: UIImage(named: "addTrackerButton"), style: .plain, target: self, action: #selector(didTapAddTrackerButton(sender:)))
            addTrackerButton.tintColor = .trackerBlack
            navigationItem.leftBarButtonItem = addTrackerButton
            
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            datePickerButton.accessibilityLabel = dateFormatter.string(from: datePicker.date)
            datePickerButton.customView?.tintColor = .trackerBlue
            navigationItem.rightBarButtonItem = datePickerButton
        }
    }
    
    private func addSubViews() {
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        view.addSubview(searchTextField)
        view.addSubview(cancelSearchTextFieldButton)
        view.addSubview(collectionView)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            plugImageView.widthAnchor.constraint(equalToConstant: 80),
            plugImageView.heightAnchor.constraint(equalToConstant: 80),
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            plugLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            plugLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func additionalConstraintsSetup() {
        widthAnchor = cancelSearchTextFieldButton.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: cancelSearchTextFieldButton.leadingAnchor, constant: -5),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            cancelSearchTextFieldButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelSearchTextFieldButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            cancelSearchTextFieldButton.centerXAnchor.constraint(equalTo: searchTextField.centerXAnchor),
            widthAnchor!
        ])
    }
    
    private func setWeekDay() {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        currentDate = components.weekday
    }
    
    private func updateCategories() {
        var newCategories = [TrackerCategory]()
        for category in categories {
            var newTrackers = [Trackers]()
            for tracker in category.trackers {
                guard let schedule = tracker.schedule else { return }
                let scheduleNumbers = schedule.map { $0.numberOfDay }
                if let day = currentDate, scheduleNumbers.contains(day) && (searchText.isEmpty || tracker.name.contains(searchText)) {
                    newTrackers.append(tracker)
                }
            }
            if newTrackers.count > 0 {
                let newCategory = TrackerCategory(categoryName: category.categoryName, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        collectionView.reloadData()
    }

    
    // MARK: - Obj-C methods
    
    @objc func didTapAddTrackerButton(sender: AnyObject) {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        present(trackerCreator, animated: true)
    }
    
    @objc func didTapDateButton(sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.weekday], from: sender.date)
        if let day = components.weekday {
            currentDate = day
            updateCategories()
        }
    }
    
    @objc func textFieldDidChanged(sender: AnyObject) {
        searchText = searchTextField.text ?? ""
        widthAnchor?.constant = 85
        updateCategories()
    }
    
    @objc func cancelButtonDidTap(sender: AnyObject) {
        searchTextField.text = ""
        searchText = ""
        widthAnchor?.constant = 0
        constraintsSetup()
        updateCategories()
    }
}

    // MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier, for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = completedTrackers.contains(where: { record in
            record.trackerID == tracker.id && record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        })
        let isEnabled = datePicker.date <= Date() || Date().yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        let completedCount = completedTrackers.filter({ record in
            record.trackerID == tracker.id
        }).count
        
        cell.configureCell(id: tracker.id,
                           name: tracker.name,
                           color: tracker.color,
                           emoji: tracker.emoji,
                           isCompleted: isCompleted,
                           isEnabled: isEnabled,
                           completedCount: completedCount)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackersCellSuplementaryView else { return UICollectionReusableView() }
        
        view.titleLabel.text = visibleCategories[indexPath.section].categoryName
        
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = visibleCategories.count
        collectionView.isHidden = count == .zero
        
        return count
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 167, height: 148)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerViewSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                                       height: UIView.layoutFittingExpandedSize.height),
                                                                withHorizontalFittingPriority: .required,
                                                                verticalFittingPriority: .fittingSizeLevel)
        return headerViewSize
    }
}

    // MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        widthAnchor?.constant = 85
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        additionalConstraintsSetup()
    }
}

    // MARK: - TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func completedTrackers(id: UUID) {
        if let index = completedTrackers.firstIndex(where: { record in
            record.trackerID == id && record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(trackerID: id, date: datePicker.date))
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerCreatorViewControllerDelegate {
    func createTracker(tracker: Trackers, categoryName: String) {
        var updatedCategory: TrackerCategory?
        var index: Int?
        
        for item in 0..<categories.count {
            if categories[item].categoryName == categoryName {
                updatedCategory = categories[item]
                index = item
            }
        }
        if updatedCategory == nil {
            categories.append(TrackerCategory(categoryName: categoryName, trackers: [tracker]))
        } else {
            let trackerCategory = TrackerCategory(categoryName: categoryName, trackers: [tracker] + (updatedCategory?.trackers ?? []))
            categories.remove(at: index ?? 0)
            categories.append(trackerCategory)
        }
        visibleCategories = categories
        updateCategories()
        collectionView.reloadData()
    }
}

