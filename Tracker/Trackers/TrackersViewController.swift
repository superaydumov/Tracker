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
    private var datePicker = UIDatePicker()
    
    // MARK: - Computed properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .trackerWhite
//        collectionView.register(EmojisCollectionViewCell.self, forCellWithReuseIdentifier: Keys.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        return formatter
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
        let cancelButton = UIButton()
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
            
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.calendar.firstWeekday = 2
            datePicker.accessibilityLabel = dateFormatter.string(from: datePicker.date)
            datePicker.addTarget(self, action: #selector(didTapDateButton(sender:)), for: .valueChanged)
            datePicker.tintColor = .trackerBlue
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerButton
        }
    }
    
    private func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        view.addSubview(searchTextField)
        view.addSubview(cancelSearchTextFieldButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            plugImageView.widthAnchor.constraint(equalToConstant: 80),
            plugImageView.heightAnchor.constraint(equalToConstant: 80),
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
            
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
    
    // MARK: - Obj-C methods
    
    @objc func didTapAddTrackerButton(sender: AnyObject) {
        let trackerCreator = TrackerCreatorViewController()
        present(trackerCreator, animated: true)
    }
    
    @objc func didTapDateButton(sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.weekday], from: sender.date)
        if let day = components.weekday {
            currentDate = day
            //TODO: update categories method
        }
    }
    
    @objc func textFieldDidChanged(sender: AnyObject) {
        searchText = searchTextField.text ?? ""
        widthAnchor?.constant = 85
        //TODO: update categories method
    }
    
    @objc func cancelButtonDidTap(sender: AnyObject) {
        searchTextField.text = ""
        searchText = ""
        widthAnchor?.constant = 0
        constraintsSetup()
        //TODO: update categories method
    }
}

    // MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: add code to these method
        return Int()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: add code to these method
        return UICollectionViewCell()
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    //TODO: add methods to these extension
}

    // MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    //TODO: add methods to these extension
}

    // MARK: - UICollectionViewDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        widthAnchor?.constant = 85
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        additionalConstraintsSetup()
    }
}

