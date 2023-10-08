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
            return "Новая привычка"
        case .nonRegular:
            return "Новое нерегулярное событие"
        }
    }
}

final class EventCreatorViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private let event: Event
    private var charactersNumber = 0
    private let charactersLimitNumber = 38
    private var heightAnchor: NSLayoutConstraint?
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = event.titleText
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
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
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
        categoryButton.setTitle("Категория", for: .normal)
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
        scheduleButton.setTitle("Расписание", for: .normal)
        scheduleButton.setTitleColor(.trackerBlack, for: .normal)
        scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        scheduleButton.titleLabel?.font = .systemFont(ofSize: 17)
        scheduleButton.contentHorizontalAlignment = .left
        scheduleButton.addTarget(self, action: #selector(scheduleButtonDidTap(sender:)), for: .touchUpInside)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scheduleButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
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
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.trackerWhite, for: .normal)
        createButton.backgroundColor = .trackerGray
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonDidTap(sender:)), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        return createButton
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
        
        addSubviews()
        constraintsSetup()
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
        
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        if event == .habit {
            eventCreatorView.addSubview(separatorView)
            eventCreatorView.addSubview(scheduleButton)
            
            scheduleButton.addSubview(scheduleChevronImage)
        }
    }
    
    private func constraintsSetup() {
        
        heightAnchor = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        
        var constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            eventCreatorView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            eventCreatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventCreatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: eventCreatorView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: eventCreatorView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: eventCreatorView.trailingAnchor),

            categoryChevronImage.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryChevronImage.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
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
                    scheduleChevronImage.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24),
                    
                ]
            } else {
                constraints += [
                    eventCreatorView.heightAnchor.constraint(equalToConstant: 75),
                    
                    categoryButton.bottomAnchor.constraint(equalTo: eventCreatorView.bottomAnchor),
                ]
            }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Obj-C methods
    
    @objc func textFieldDidChange(sender: AnyObject) {
        guard let number = textField.text?.count else { return }
        charactersNumber = number
        if charactersNumber < charactersLimitNumber {
            errorLabel.text = ""
            heightAnchor?.constant = 0
        } else {
            errorLabel.text = "Ограничение 38 символов"
            heightAnchor?.constant = 22
        }
    }
    
    @objc func categoryButtonDidTap(sender: AnyObject) {
        //TODO: add code to jump to category viewController
    }
    
    @objc func scheduleButtonDidTap(sender: AnyObject) {
        //TODO: add code to jump to schedule view controller
    }
    
    @objc func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @objc func createButtonDidTap(sender: AnyObject) {
        //TODO: code to add tracker
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
}

    // MARK: - UITextField extension

extension UITextField {
    
    func indentSize(leftSize:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: leftSize, height: self.frame.height))
        self.leftViewMode = .always
    }
}
