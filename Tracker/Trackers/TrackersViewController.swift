//
//  ViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 30.09.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private var currentDate: Int?
    private var searchText: String = ""
    private var widthAnchor: NSLayoutConstraint?
    
    private var categories = [TrackerCategory]()
    private var visibleCategories = [TrackerCategory]()
    private var completedTrackers = [TrackerRecord]()
    private var pinnedTrackers = [Trackers]()
    private var selectedFilter: Filters?
    
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    private let params = GeometricParams(cellCount: 2, cellHeight: 148, cellSpacing: 9, lineSpacing: 16)
    
    // MARK: - Localized strings
    
    private let trackersPlugLabelText = NSLocalizedString("trackersPlugLabel", comment: "Trackers plugLabel text")
    private let trackersSearchPlugLabelText = NSLocalizedString("trackersSearchPlugLabel", comment: "Trackers searchPlugLabel text")
    private let searchTextFieldPlaceholderText = NSLocalizedString("searchTextFieldPlaceholder", comment: "SearchTextField placeholder text")
    private let cancelButtonLabelText = NSLocalizedString("cancelButtonLabel", comment: "cancelButton label text")
    private let trackersHeaderText = NSLocalizedString("trackersHeader", comment: "trackersHeader text")
    private let pinnedCategoriesText = NSLocalizedString("pinnedCategories", comment: "Text for pinned category")
    private let pinTrackerText = NSLocalizedString("pinTracker", comment: "Pin tracker in context menu")
    private let unpinTrackerText = NSLocalizedString("unpinTracker", comment: "Unpin tracker in context menu")
    private let trackerContextMenuChangeText = NSLocalizedString("trackerContextMenuChange", comment: "Change tracker in context menu")
    private let trackerContextMenuDeleteText = NSLocalizedString("trackerContextMenuDelete", comment: "Delete tracker in context menu")
    private let trackerAlertMessageText = NSLocalizedString("trackerAlertMessage", comment: "")
    private let trackerAlertFirstButtonText = NSLocalizedString("trackerAlertFirstButton", comment: "")
    private let trackerAlertSecondButtonText = NSLocalizedString("trackerAlertSecondButton", comment: "")
    private let filtersButtonText = NSLocalizedString("filtersButton", comment: "Filters button in collectionView")
    
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
        datePicker.layer.backgroundColor = UIColor.trackerDatePicker.cgColor
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(didTapDateButton(sender:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    private lazy var plugView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        plugLabel.text = trackersPlugLabelText
        plugLabel.textAlignment = .center
        plugLabel.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return plugLabel
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: searchTextFieldPlaceholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.trackerSearchTextFieldPlaceholder as Any])
        searchTextField.textColor = .trackerBlack
        searchTextField.font = .systemFont(ofSize: 17)
        searchTextField.backgroundColor = .trackerSearchTextField
        searchTextField.layer.cornerRadius = 10
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textFieldDidChanged(sender:)), for: .editingChanged)
        searchTextField.delegate = self
        
        return searchTextField
    }()
    
    private lazy var cancelSearchTextFieldButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelButtonLabelText, for: .normal)
        cancelButton.setTitleColor(.trackerBlue, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap(sender:)), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private lazy var filtersButton: UIButton = {
        let filtersButton = UIButton(type: .system)
        filtersButton.overrideUserInterfaceStyle = .light
        filtersButton.backgroundColor = .trackerBlue
        filtersButton.layer.cornerRadius = 16
        filtersButton.setTitle(filtersButtonText, for: .normal)
        filtersButton.setTitleColor(.trackerWhite, for: .normal)
        filtersButton.titleLabel?.font = .systemFont(ofSize: 17)
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.addTarget(self, action: #selector(filtersButtonDidTap(sender:)), for: .touchUpInside)
        
        return filtersButton
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        self.hideKeyboardWhenTappedAround()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = false
        
        setWeekDay()
        updateCategories(with: trackerCategoryStore.trackerCategories)
        completedTrackers = trackerRecordStore.trackerRecords
        navBarSetup()
        addSubViews()
        constraintsSetup()
        additionalConstraintsSetup()
        
        do {
            completedTrackers = try trackerRecordStore.fetchTrackers()
        } catch {
            print("Error with fetchTrackers: \(error.localizedDescription)")
        }
        
        trackerCategoryStore.delegate = self
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        alertPresenter = AlertPresenter(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView(sender:)), name: NSNotification.Name("reloadCollectionView"), object: nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    private func navBarSetup() {
        if let navigationBar = navigationController?.navigationBar {
            title = trackersHeaderText
            navigationBar.prefersLargeTitles = true
            
            let addTrackerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddTrackerButton(sender:)))
            addTrackerButton.tintColor = .trackerBlack
            navigationItem.leftBarButtonItem = addTrackerButton
            
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            datePickerButton.accessibilityLabel = dateFormatter.string(from: datePicker.date)
            datePickerButton.customView?.tintColor = .trackerBlue
            navigationItem.rightBarButtonItem = datePickerButton
        }
    }
    
    private func addSubViews() {
        view.addSubview(plugView)
        plugView.addSubview(plugImageView)
        plugView.addSubview(plugLabel)
        
        view.addSubview(searchTextField)
        view.addSubview(cancelSearchTextFieldButton)
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            plugView.heightAnchor.constraint(equalToConstant: 110),
            plugView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            plugView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            plugView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugImageView.widthAnchor.constraint(equalToConstant: 80),
            plugImageView.heightAnchor.constraint(equalToConstant: 80),
            plugImageView.topAnchor.constraint(equalTo: plugView.topAnchor),
            plugImageView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.leadingAnchor.constraint(equalTo: plugView.leadingAnchor, constant: 16),
            plugLabel.trailingAnchor.constraint(equalTo: plugView.trailingAnchor, constant: -16),
            plugLabel.heightAnchor.constraint(equalToConstant: 18),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114)
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
            cancelSearchTextFieldButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cancelSearchTextFieldButton.centerXAnchor.constraint(equalTo: searchTextField.centerXAnchor),
            widthAnchor!
        ])
    }
    
    private func setWeekDay() {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        currentDate = components.weekday
    }
    
    private func updateCategories(with categories: [TrackerCategory]) {
        var newCategories = [TrackerCategory]()
        var pinnedTrackers = [Trackers]()
        
        for category in categories {
            var newTrackers = [Trackers]()
            for tracker in category.visibleTrackers(filterString: searchText, pinned: nil) {
                guard let schedule = tracker.schedule else { return }
                let scheduleNumbers = schedule.map { $0.numberOfDay }
                if let day = currentDate, scheduleNumbers.contains(day) {
                    
                    if selectedFilter == .completedTrackers {
                        filtersButton.setTitleColor(.trackerRed, for: .normal)
                        showSearchPlug(filter: .completedTrackers)
                        if !completedTrackers.contains(where: { record in
                            record.trackerID == tracker.id &&
                            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
                        }) {
                            continue
                        }
                    }
                    
                    if selectedFilter == .inCompletedTrackers {
                        filtersButton.setTitleColor(.trackerRed, for: .normal)
                        showSearchPlug(filter: .inCompletedTrackers)
                        if completedTrackers.contains(where: { record in
                            record.trackerID == tracker.id &&
                            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
                        }) {
                            continue
                        }
                    }
                    
                    if tracker.pinned == true {
                        pinnedTrackers.append(tracker)
                    } else {
                        newTrackers.append(tracker)
                    }
                }
            }
            if newTrackers.count > 0 {
                let newCategory = TrackerCategory(categoryName: category.categoryName, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        self.pinnedTrackers = pinnedTrackers
        collectionView.reloadData()
    }
    
    private func changePlugs(_ text: String) {
        plugImageView.image = text.isEmpty ? UIImage(named: "trackersPlugImage") : UIImage(named: "trackersNotFoundPlugImage")
        plugLabel.text = text.isEmpty ? trackersPlugLabelText : trackersSearchPlugLabelText
    }
    
    private func showSearchPlug(filter: Filters) {
        let changeProperty: Bool = selectedFilter == filter
        plugImageView.image = changeProperty ? UIImage(named: "trackersNotFoundPlugImage") : UIImage(named: "trackersPlugImage")
        plugLabel.text = changeProperty ? trackersSearchPlugLabelText: trackersPlugLabelText
    }
    
    private func trackerDeleteAlert(trackerToDelete: Trackers) {
        let model = AlertModel(
            title: trackerAlertMessageText,
            message: nil,
            firstButtonText: trackerAlertFirstButtonText,
            secondButtontext: trackerAlertSecondButtonText,
            firstCompletion: { [weak self] in
                guard let self else { return }
                try? self.trackerStore.deleteTracker(trackerToDelete)
                try? self.trackerRecordStore.deleteAllRecords(with: trackerToDelete.id)
            })
        
        alertPresenter?.showAlert(model: model)
    }
    
    private func makeContextMenu(indexPath: IndexPath) -> UIMenu {
        let tracker: Trackers
        if indexPath.section == 0 {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            tracker = visibleCategories[indexPath.section - 1].visibleTrackers(filterString: searchText, pinned: false)[indexPath.row]
        }
        
        var pinnedImage: UIImage
        if tracker.pinned == false {
            pinnedImage = UIImage(systemName: "pin.fill") ?? UIImage()
        } else {
            pinnedImage = UIImage(systemName: "pin.slash.fill") ?? UIImage()
        }
        
        let pinnedTitle = tracker.pinned == true ? unpinTrackerText : pinTrackerText
        let pin = UIAction(title: pinnedTitle, image: pinnedImage,
                           handler: { [weak self] action in
            guard let self else { return }
            try? self.trackerStore.togglePinTracker(tracker)
            print("tracker pinned")
        })
        
        let editImage = UIImage(systemName: "square.and.pencil")
        let edit = UIAction(title: trackerContextMenuChangeText, image: editImage,
                            handler: { [weak self] action in
            guard let self else { return }
            let editViewController = EventCreatorViewController(event: .habit)
            editViewController.editTracker = tracker
            editViewController.category = tracker.category
            self.present(editViewController, animated: true)
            print("tracker editing")
        })
        
        let deleteImage = UIImage(systemName: "trash")
        let delete = UIAction(title: trackerContextMenuDeleteText, image: deleteImage, attributes: .destructive,
                              handler: { [weak self] action in
            guard let self else { return }
            self.trackerDeleteAlert(trackerToDelete: tracker)
            print("tracker deleting")
        })
        
        return UIMenu(children: [pin, edit, delete])
    }
    
    // MARK: - Obj-C methods
    
    @objc private func didTapAddTrackerButton(sender: AnyObject) {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        present(trackerCreator, animated: true)
    }
    
    @objc private func didTapDateButton(sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.weekday], from: sender.date)
        if let day = components.weekday {
            currentDate = day
            updateCategories(with: trackerCategoryStore.trackerCategories)
        }
        if selectedFilter == .todayTrackers {
            selectedFilter = .allTrackers
        }
    }
    
    @objc private func textFieldDidChanged(sender: AnyObject) {
        searchText = searchTextField.text ?? ""
        changePlugs(searchText)
        widthAnchor?.constant = 83
        
        updateCategories(with: trackerCategoryStore.predicateFetch(trackerName: searchText))
    }
    
    @objc private func cancelButtonDidTap(sender: AnyObject) {
        searchTextField.text = ""
        searchText = ""
        changePlugs(searchText)
        widthAnchor?.constant = 0
        constraintsSetup()
        
        updateCategories(with: trackerCategoryStore.trackerCategories)
    }
    
    @objc func reloadCollectionView(sender: AnyObject) {
        updateCategories(with: trackerCategoryStore.trackerCategories)
    }
    
    @objc func filtersButtonDidTap(sender: AnyObject) {
        let filtersViewController = FiltersViewController()
        filtersViewController.selectedFilter = selectedFilter
        filtersViewController.delegate = self
        present(filtersViewController, animated: true)
    }
}

    // MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return pinnedTrackers.count
        } else {
            return visibleCategories[section - 1].visibleTrackers(filterString: searchText, pinned: false).count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier, for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        let tracker: Trackers
        
        if indexPath.section == 0 {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            tracker = visibleCategories[indexPath.section - 1].visibleTrackers(filterString: searchText, pinned: false)[indexPath.row]
        }

        let isCompleted = completedTrackers.contains(where: { record in
            record.trackerID == tracker.id &&
            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
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
                           completedCount: completedCount,
                           pinned: tracker.pinned ?? false)
        
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
        
        if indexPath.section == 0 {
            view.titleLabel.text = pinnedCategoriesText
        } else {
            view.titleLabel.text = visibleCategories[indexPath.section - 1].categoryName
        }
        
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = visibleCategories.count
        collectionView.isHidden = count == .zero && pinnedTrackers.count == .zero
        filtersButton.isHidden = collectionView.isHidden && (selectedFilter == .allTrackers || selectedFilter == nil)
        
        return count + 1
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSizeCompensator: CGFloat = 32
        let availableWidth = collectionView.frame.width - params.paddingWidth - collectionViewSizeCompensator
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        
        return CGSize(width: cellWidth, height: params.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return params.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && pinnedTrackers.count == .zero {
            return .zero
        }
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        let headerViewSize = headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .fittingSizeLevel)
        
        return headerViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

    // MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row):\(indexPath.section)" as NSString
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { suggestedActions in
            return self.makeContextMenu(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        
        let components = identifier.components(separatedBy: ":")
        print(identifier)
        
        guard let rowString = components.first,
              let sectionString = components.last,
              let row = Int(rowString),
              let section = Int(sectionString) else { return nil }
        let indexPath = IndexPath(row: row, section: section)
                
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else { return nil }
        
        return UITargetedPreview(view: cell.menuView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let bottomOffset = collectionView.contentOffset.y + collectionView.frame.height
        let contentHeight = collectionView.contentSize.height
        
        if bottomOffset >= contentHeight {
            filtersButton.isHidden = true
        } else {
            filtersButton.isHidden = false
        }
    }
}

    // MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        widthAnchor?.constant = 83
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        additionalConstraintsSetup()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

    // MARK: - TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func completedTrackers(id: UUID) {
        if let index = completedTrackers.firstIndex(where: { record in
            record.trackerID == id && record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        }) {
            completedTrackers.remove(at: index)
            try? trackerRecordStore.deleteTrackerRecord(with: id)
        } else {
            completedTrackers.append(TrackerRecord(trackerID: id, date: datePicker.date))
            try? trackerRecordStore.addNewTracker(TrackerRecord(trackerID: id, date: datePicker.date))
        }
        updateCategories(with: trackerCategoryStore.trackerCategories)
    }
}

    // MARK: - TrackerCreatorViewControllerDelegate

extension TrackersViewController: TrackerCreatorViewControllerDelegate {
    func createTracker(tracker: Trackers, categoryName: String) {
        var updatedCategory: TrackerCategory?
        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
        
        for item in 0..<categories.count {
            if categories[item].categoryName == categoryName {
                updatedCategory = categories[item]
            }
        }
        if updatedCategory != nil {
            try? trackerCategoryStore.addTracker(tracker, to: updatedCategory!)
        } else {
            let trackerCategory = TrackerCategory(categoryName: categoryName, trackers: [tracker])
            updatedCategory = trackerCategory
            try? trackerCategoryStore.addNewTrackerCategory(updatedCategory!)
        }
        updateCategories(with: trackerCategoryStore.trackerCategories)
        dismiss(animated: true)
    }
}

    // MARK: - FilterViewControllerDelegate

extension TrackersViewController: FilterViewControllerDelegate {
    func filterSelected(filter: Filters) {
        self.selectedFilter = filter
        searchText = ""
        switch filter {
        case .allTrackers:
            filtersButton.setTitleColor(.trackerWhite, for: .normal)
            changePlugs(searchText)
            updateCategories(with: trackerCategoryStore.trackerCategories)
        case .todayTrackers:
            filtersButton.setTitleColor(.trackerWhite, for: .normal)
            changePlugs(searchText)
            datePicker.date = Date()
            didTapDateButton(sender: datePicker)
        case .completedTrackers:
            updateCategories(with: trackerCategoryStore.trackerCategories)
        case .inCompletedTrackers:
            updateCategories(with: trackerCategoryStore.trackerCategories)
        }
    }
}

    // MARK: - TrackerCategoryStoreDelegate

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: StoreUpdate) {
        updateCategories(with: trackerCategoryStore.trackerCategories)
        
        collectionView.reloadData()
    }
}

    // MARK: - TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: StoreUpdate) {
        updateCategories(with: trackerCategoryStore.trackerCategories)
        
        collectionView.reloadData()
    }
}

    // MARK: - TrackerRecordStoreDelegate

extension TrackersViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: StoreUpdate) {
        completedTrackers = trackerRecordStore.trackerRecords
        
        collectionView.reloadData()
    }
}

