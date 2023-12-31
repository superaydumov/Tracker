//
//  EventCreatorViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 08.10.2023.
//

import UIKit

enum Event {
    case habit
    case nonRegular
    
    var titleText: String {
        switch self {
        case .habit:
            return NSLocalizedString("newHabit", comment: "")
        case .nonRegular:
            return NSLocalizedString("newIrregular", comment: "")
        }
    }
    
    var editTitleText: String {
        switch self {
        case .habit:
            return NSLocalizedString("editTitle", comment: "")
        case .nonRegular:
            return NSLocalizedString("editTitle", comment: "")
        }
    }
}

final class EventCreatorViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌",
        "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
    private let event: Event
    private var charactersNumber = 0
    private let charactersLimitNumber = 38
    private var heightAnchor: NSLayoutConstraint?
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    private var completedTrackers = [TrackerRecord]()
    
    private var scheduleSubtitle = ""
    private var schedule = [WeekDay]() {
        didSet {
            createButtonUpdate()
        }
    }
    
    private var categorySubtitle = ""
    var category: TrackerCategory? = nil {
        didSet {
            createButtonUpdate()
        }
    }
    
    private var selectedEmojiCell: IndexPath? = nil
    private var selectedColorCell: IndexPath? = nil
    
    private var selectedEmoji: String? = nil {
        didSet {
            createButtonUpdate()
        }
    }
    private var selectedColor: UIColor? = nil{
        didSet {
            createButtonUpdate()
        }
    }
    
    var editTracker: Trackers?
    weak var delegate: EventCreatorViewControllerDelegate?
    
    // MARK: - Localized strings
    
    private let textFieldPlaceHolderText = NSLocalizedString("textFieldPlaceHolder", comment: "EventCreator textFieldPlaceHolder text")
    private let categoryButtonLabelText = NSLocalizedString("categoryButtonLabel", comment: "EventCreator categoryButtonLabel text")
    private let scheduleButtonLabelText = NSLocalizedString("scheduleButtonLabel", comment: "EventCreator scheduleButtonLabel text")
    private let cancelButtonLabelText = NSLocalizedString("cancelButtonLabel", comment: "EventCreator cancelButtonLabel text")
    private let createButtonLabelText = NSLocalizedString("createButtonLabel", comment: "EventCreator createButtonLabel text")
    private let restrictorLabelText = NSLocalizedString("restrictorLabel", comment: "EventCreator restrictorLabel text")
    private let emojiSectionLabelText = NSLocalizedString("emojiSectionLabel", comment: "EventCreator emojiSectionLabel text")
    private let colorsSectionLabelText = NSLocalizedString("colorsSectionLabel", comment: "EventCreator colorsSectionLabel text")
    private let saveButtonTitleText = NSLocalizedString("saveButtonTitle", comment: "EventCreator saveButtonLabel text")
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = editTracker == nil ? event.titleText : event.editTitleText
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    private lazy var daysLabel: UILabel = {
        let daysLabel = UILabel()
        
        completedTrackers = trackerRecordStore.trackerRecords
        let completedCount = completedTrackers.filter({ record in
            record.trackerID == editTracker?.id
        }).count
        
        daysLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDay", comment: "дней"), completedCount)
        daysLabel.textColor = .trackerBlack
        daysLabel.textAlignment = .center
        daysLabel.font = .systemFont(ofSize: 38, weight: .bold)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return daysLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .trackerWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = textFieldPlaceHolderText
        textField.textColor = .trackerBlack
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.indentSize(leftSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .trackerRed
        errorLabel.font = .systemFont(ofSize: 17)
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return errorLabel
    }()
    
    private lazy var eventCreatorView: UIView = {
        let eventView = UIView()
        eventView.backgroundColor = .trackerBackground
        eventView.layer.cornerRadius = 16
        eventView.translatesAutoresizingMaskIntoConstraints = false
        
        return eventView
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .trackerGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return separatorView
    }()
    
    private lazy var categoryChevronImage: UIImageView = {
        let chevronImage = UIImageView()
        chevronImage.image = UIImage(named: "chevronImage")
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        
        return chevronImage
    }()
    
    private lazy var scheduleChevronImage: UIImageView = {
        let chevronImage = UIImageView()
        chevronImage.image = UIImage(named: "chevronImage")
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        
        return chevronImage
    }()
    
    private lazy var categoryButton: UIButton = {
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle(categoryButtonLabelText, for: .normal)
        categoryButton.setTitleColor(.trackerBlack, for: .normal)
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 17)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.addTarget(self, action: #selector(categoryButtonDidTap(sender:)), for: .touchUpInside)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return categoryButton
    }()
    
    private lazy var scheduleButton: UIButton = {
        let scheduleButton = UIButton(type: .system)
        scheduleButton.setTitle(scheduleButtonLabelText, for: .normal)
        scheduleButton.setTitleColor(.trackerBlack, for: .normal)
        scheduleButton.titleLabel?.font = .systemFont(ofSize: 17)
        scheduleButton.contentHorizontalAlignment = .left
        scheduleButton.addTarget(self, action: #selector(scheduleButtonDidTap(sender:)), for: .touchUpInside)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scheduleButton
    }()
    
    private lazy var scheduleButtonSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 17)
        subtitle.textColor = .trackerGray
        subtitle.text = scheduleSubtitle
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        return subtitle
    }()
    
    private lazy var categoryButtonSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 17)
        subtitle.textColor = .trackerGray
        subtitle.text = categorySubtitle
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        return subtitle
    }()
    
    private lazy var buttonsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .trackerWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelButtonLabelText, for: .normal)
        cancelButton.setTitleColor(.trackerRed, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderColor = UIColor.trackerRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap(sender:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton(type: .system)
        var title = editTracker == nil ? createButtonLabelText : saveButtonTitleText
        createButton.setTitle(title, for: .normal)
        createButton.setTitleColor(.trackerWhite, for: .normal)
        createButton.backgroundColor = .trackerGray
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonDidTap(sender:)), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        return createButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .trackerWhite
        collectionView.register(EventCreatorCollectionViewCell.self, forCellWithReuseIdentifier: EventCreatorCollectionViewCell.cellIdentifier)
        collectionView.register(EventCreatorSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventCreatorSuplementaryView.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        self.hideKeyboardWhenTappedAround()
        
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubviews()
        constraintsSetup()
        
        categorySubtitleUpdate()
        scheduleSubtitleUpdate()
        editingTrackerElementsSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let indexPathEmoji = emojies.firstIndex(where: {$0 == selectedEmoji}) else { return }
        let cellEmoji = self.collectionView.cellForItem(at: IndexPath(row: indexPathEmoji, section: 0))
        cellEmoji?.backgroundColor = .trackerLightGray
        selectedEmojiCell = IndexPath(row: indexPathEmoji, section: 0)
        
        guard let indexPathColor = colors.firstIndex(where: {$0.hexString == selectedColor?.hexString}) else { return }
        let cellColor = self.collectionView.cellForItem(at: IndexPath(row: indexPathColor, section: 1))
        cellColor?.layer.borderWidth = 3
        cellColor?.layer.cornerRadius = 16
        cellColor?.layer.borderColor = selectedColor?.withAlphaComponent(0.3).cgColor
        selectedColorCell = IndexPath(item: indexPathColor, section: 1)
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(topLabel)
        view.addSubview(scrollView)
        
        scrollView.addSubview(textField)
        scrollView.addSubview(errorLabel)
        scrollView.addSubview(eventCreatorView)
        
        eventCreatorView.addSubview(categoryButton)
        
        categoryButton.addSubview(categoryChevronImage)
        
        scrollView.addSubview(collectionView)
        
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        if event == .habit {
            eventCreatorView.addSubview(separatorView)
            eventCreatorView.addSubview(scheduleButton)
            
            scheduleButton.addSubview(scheduleChevronImage)
        }
        
        if editTracker != nil {
            scrollView.addSubview(daysLabel)
        }
    }
    
    private func constraintsSetup() {
        let topInset: CGFloat = editTracker == nil ? 0 : 78
        heightAnchor = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        
        var constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topInset),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heightAnchor!,
            
            eventCreatorView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            eventCreatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventCreatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: eventCreatorView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: eventCreatorView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: eventCreatorView.trailingAnchor),

            categoryChevronImage.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryChevronImage.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -16),

            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: eventCreatorView.bottomAnchor, constant: 16),
            collectionView.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - 36),
            collectionView.heightAnchor.constraint(equalToConstant: 536)
            ]
        
            if event == .habit {
                constraints += [
                    eventCreatorView.heightAnchor.constraint(equalToConstant: 150),
                    
                    separatorView.centerYAnchor.constraint(equalTo: eventCreatorView.centerYAnchor),
                    separatorView.leadingAnchor.constraint(equalTo: eventCreatorView.leadingAnchor, constant: 16),
                    separatorView.trailingAnchor.constraint(equalTo: eventCreatorView.trailingAnchor, constant: -16),
                    separatorView.heightAnchor.constraint(equalToConstant: 1),
                    
                    categoryButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
                    
                    scheduleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
                    scheduleButton.leadingAnchor.constraint(equalTo: eventCreatorView.leadingAnchor),
                    scheduleButton.trailingAnchor.constraint(equalTo: eventCreatorView.trailingAnchor),
                    scheduleButton.bottomAnchor.constraint(equalTo: eventCreatorView.bottomAnchor),

                    scheduleChevronImage.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
                    scheduleChevronImage.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24)
                ]
            } else {
                constraints += [
                    eventCreatorView.heightAnchor.constraint(equalToConstant: 75),
                    
                    categoryButton.bottomAnchor.constraint(equalTo: eventCreatorView.bottomAnchor)
                ]
            }
        
        if editTracker != nil {
            constraints += [
                daysLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
                daysLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func scheduleSubtitleUpdate() {
        if scheduleSubtitle == "" {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        } else {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: -15, left: 16, bottom: 0, right: 0)
            scheduleButton.addSubview(scheduleButtonSubtitle)
            NSLayoutConstraint.activate([
                scheduleButtonSubtitle.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
                scheduleButtonSubtitle.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -14),
                scheduleButtonSubtitle.heightAnchor.constraint(equalToConstant: 22)
            ])
            scheduleButtonSubtitle.text = scheduleSubtitle
        }
    }
    
    private func categorySubtitleUpdate() {
        if categorySubtitle == "" {
            categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        } else {
            categoryButton.titleEdgeInsets = UIEdgeInsets(top: -15, left: 16, bottom: 0, right: 0)
            categoryButton.addSubview(categoryButtonSubtitle)
            NSLayoutConstraint.activate([
                categoryButtonSubtitle.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
                categoryButtonSubtitle.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14),
                categoryButtonSubtitle.heightAnchor.constraint(equalToConstant: 22)
            ])
            categoryButtonSubtitle.text = categorySubtitle
        }
    }
    
    private func createButtonUpdate() {
        createButton.isEnabled = textField.text?.isEmpty == false && selectedColor != nil && selectedEmoji != nil && category != nil
        
        if event == .habit {
            createButton.isEnabled = createButton.isEnabled && !schedule.isEmpty
        }
        
        if createButton.isEnabled {
            createButton.backgroundColor = .trackerBlack
        } else {
            createButton.backgroundColor = .trackerGray
        }
    }
    
    private func editingTrackerElementsSetup() {
        if let editTracker = editTracker {
            textField.text = editTracker.name
            categorySubtitle = category?.categoryName ?? ""
            schedule = editTracker.schedule ?? []
            selectedEmoji = editTracker.emoji
            selectedColor = editTracker.color
            
            categorySubtitleUpdate()
            createSchedule(schedule: schedule)
            scheduleSubtitleUpdate()
        }
    }
    
    // MARK: - Obj-C methods
    
    @objc private func textFieldDidChange(sender: AnyObject) {
        createButtonUpdate()
        
        guard let number = textField.text?.count else { return }
        charactersNumber = number
        if charactersNumber < charactersLimitNumber {
            errorLabel.text = ""
            heightAnchor?.constant = 0
        } else {
            errorLabel.text = restrictorLabelText
            heightAnchor?.constant = 22
        }
    }
    
    @objc private func categoryButtonDidTap(sender: AnyObject) {
        let categoryViewController = CategoryViewController(delegate: self, selectedCategory: category)
        present(categoryViewController, animated: true)
    }
    
    @objc private func scheduleButtonDidTap(sender: AnyObject) {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        scheduleViewController.schedule = schedule
        present(scheduleViewController, animated: true)
    }
    
    @objc private func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @objc private func createButtonDidTap(sender: AnyObject) {
        var tracker: Trackers?
        guard let selectedEmoji, let selectedColor else { return }
        
        if editTracker == nil {
            if event == .habit {
                tracker = Trackers(id: UUID(), name: textField.text ?? "", color: selectedColor, emoji: selectedEmoji, schedule: schedule, pinned: false)
                
                guard let tracker else { return }
                delegate?.createTracker(tracker: tracker, categoryName: category?.categoryName ?? "Без категории")
            } else {
                tracker = Trackers(id: UUID(), name: textField.text ?? "", color: selectedColor, emoji: selectedEmoji, schedule: WeekDay.allCases, pinned: false)
                
                guard let tracker else { return }
                delegate?.createTracker(tracker: tracker, categoryName: category?.categoryName ?? "Без категории")
            }
        }
        else {
            guard let editTracker else { return }

            try? trackerStore.updateTracker(newName: textField.text ?? "",
                                            newCategory: category?.categoryName ?? "Без категории",
                                            newSchedule: schedule,
                                            newEmoji: selectedEmoji,
                                            newColor: selectedColor.hexString,
                                            editableTracker: editTracker)
            delegate?.createTracker(tracker: editTracker, categoryName: category?.categoryName ?? "Без категории")
            dismiss(animated: true)
        }
    }
}

    // MARK: - UITextFieldDelegate

extension EventCreatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maximumLength = charactersLimitNumber
        let currentString = (textField.text ?? "") as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: string)
        
        return updatedString.count <= maximumLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
}

    // MARK: - ScheduleViewControllerDelegate

extension EventCreatorViewController: ScheduleViewControllerDelegate {
    func createSchedule(schedule: [WeekDay]) {
        self.schedule = schedule
        
        let scheduleString = schedule.map { $0.shortName }.joined(separator: ", ")
        
        let allDaysArray: [String] = [NSLocalizedString("mondayShort", comment: ""),
                                      NSLocalizedString("tuesdayShort", comment: ""),
                                      NSLocalizedString("wednesdayShort", comment: ""),
                                      NSLocalizedString("thursdayShort", comment: ""),
                                      NSLocalizedString("fridayShort", comment: ""),
                                      NSLocalizedString("saturdayShort", comment: ""),
                                      NSLocalizedString("sundayShort", comment: "")]
        
        let workDaysArray: [String] = [NSLocalizedString("mondayShort", comment: ""),
                                       NSLocalizedString("tuesdayShort", comment: ""),
                                       NSLocalizedString("wednesdayShort", comment: ""),
                                       NSLocalizedString("thursdayShort", comment: ""),
                                       NSLocalizedString("fridayShort", comment: "")]
        
        let holidaysArray: [String] = [NSLocalizedString("saturdayShort", comment: ""),
                                       NSLocalizedString("sundayShort", comment: "")]
        
        if allDaysArray.allSatisfy(scheduleString.contains) {
            scheduleSubtitle = NSLocalizedString("everyDay", comment: "")
        } else if scheduleString == workDaysArray.map({$0}).joined(separator: ", ") {
            scheduleSubtitle = NSLocalizedString("workDays", comment: "")
        } else if scheduleString == holidaysArray.map({$0}).joined(separator: ", ") {
            scheduleSubtitle = NSLocalizedString("weekEnds", comment: "")
        } else {
            scheduleSubtitle = scheduleString
        }
        
        scheduleSubtitleUpdate()
    }
}

    // MARK: - CategoryViewControllerDelegate

extension EventCreatorViewController: CategoryViewModelDelegate {
    func createCategory(category: TrackerCategory) {
        self.category = category
        let categoryString = category.categoryName
        categorySubtitle = categoryString
        categorySubtitleUpdate()
    }
}

    // MARK: - UICollectionViewDataSource

extension EventCreatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var value = Int()
        
        if section == 0 {
            value = emojies.count
        } else if section == 1 {
            value = colors.count
        }
        
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCreatorCollectionViewCell.cellIdentifier, for: indexPath) as? EventCreatorCollectionViewCell else { return UICollectionViewCell() }
        
        let emoji = emojies[indexPath.row]
        let color = colors[indexPath.row]
        
        cell.configureCell(indexPath: indexPath, emoji: emoji, color: color)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension EventCreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EventCreatorSuplementaryView else { return UICollectionReusableView() }
        
        if section == 0 {
            view.titleLabel.text = emojiSectionLabelText
        } else if section == 1 {
            view.titleLabel.text = colorsSectionLabelText
        }
        
        return view
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

    // MARK: - UICollectionViewDelegate

extension EventCreatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? EventCreatorCollectionViewCell else { return }
        
        if section == 0 {
            if selectedEmojiCell != nil {
                collectionView.deselectItem(at: selectedEmojiCell!, animated: true)
                collectionView.cellForItem(at: selectedEmojiCell!)?.backgroundColor = .trackerWhite
            }
            cell.backgroundColor = .trackerLightGray
            selectedEmoji = cell.getCellText()
            selectedEmojiCell = indexPath
        } else if section == 1 {
            if selectedColorCell != nil {
                collectionView.deselectItem(at: selectedColorCell!, animated: true)
                collectionView.cellForItem(at: selectedColorCell!)?.layer.borderWidth = 0
            }
            selectedColor = cell.getCellColor()
            selectedColorCell = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? EventCreatorCollectionViewCell else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        cell.backgroundColor = .trackerWhite
        cell.layer.borderWidth = 0
        
        if section == 0 {
            selectedEmojiCell = nil
            selectedEmoji = nil
        } else if section == 1 {
            selectedColorCell = nil
            selectedColor = nil
        }
    }
}
