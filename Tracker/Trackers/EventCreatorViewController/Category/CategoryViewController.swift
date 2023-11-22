//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 09.10.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private var viewModel: CategoryViewModel
    private var alertPresenter: AlertPresenterProtocol?
    
    private let topLabelText = NSLocalizedString("topLabel", comment: "CtaegoryVC topLabel text")
    private let plugLabelText = NSLocalizedString("plugLabel", comment: "CtaegoryVC plugLabel text")
    private let categoryButonTitleText = NSLocalizedString("categoryButonTitle", comment: "CtaegoryVC categoryButonTitle text")
    private let contextMenuChangeText = NSLocalizedString("contextMenuChange", comment: "CtaegoryVC contextMenuChange text")
    private let contextMenuDeleteText = NSLocalizedString("contextMenuDelete", comment: "CtaegoryVC contextMenuDelete text")
    
    private let alertTitleText = NSLocalizedString("alertTitle", comment: "")
    private let alertMessageText = NSLocalizedString("alertMessage", comment: "")
    private let alertFirstButtonText = NSLocalizedString("alertFirstButton", comment: "")
    private let alertSecondButtonText = NSLocalizedString("alertSecondButton", comment: "")
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = topLabelText
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
        tableView.separatorColor = .trackerGray
        tableView.alwaysBounceVertical = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
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
        plugLabel.text = plugLabelText
        plugLabel.numberOfLines = 2
        plugLabel.textAlignment = .center
        plugLabel.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return plugLabel
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle(categoryButonTitleText, for: .normal)
        categoryButton.setTitleColor(.trackerWhite, for: .normal)
        categoryButton.backgroundColor = .trackerBlack
        categoryButton.layer.cornerRadius = 16
        categoryButton.addTarget(self, action: #selector(createCategoryButtonDidTap(sender:)), for: .touchUpInside)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return categoryButton
    }()
    
    // MARK: - Lifecycle
    
    init(delegate: CategoryViewModelDelegate?, selectedCategory: TrackerCategory?) {
        viewModel = CategoryViewModel(selectedCategory: selectedCategory, delegate: delegate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        alertPresenter = AlertPresenter(delegate: self)
        
        addSubViews()
        constraintsSetup()
        
        viewModel.onChange = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private methods
    
    private func addSubViews() {
        view.addSubview(topLabel)
        view.addSubview(plugView)
        
        plugView.addSubview(plugImageView)
        plugView.addSubview(plugLabel)
        view.addSubview(createCategoryButton)
        
        view.addSubview(tableView)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -16),
            
            plugView.heightAnchor.constraint(equalToConstant: 125),
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
            plugLabel.heightAnchor.constraint(equalToConstant: 36),
            
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func categoryDeleteAlert(category: TrackerCategory) {
        let model = AlertModel(title: alertTitleText,
                               message: alertMessageText,
                               firstButtonText: alertFirstButtonText,
                               secondButtontext: alertSecondButtonText,
                               firstCompletion: { [weak self] in
            guard let self else { return }
            self.viewModel.deleteTrackerCategory(category)
            
            NotificationCenter.default.post(name: NSNotification.Name("reloadCollectionView"), object: nil)
        })
        
        alertPresenter?.showAlert(model: model)
    }
    
    // MARK: - Obj-C methods
    
    @objc func createCategoryButtonDidTap(sender: AnyObject) {
        let creationViewController = CategoryCreatorViewController(categoryEvent: .creation)
        present(creationViewController, animated: true)
    }
}

    //MARK: UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.categories.count
        tableView.isHidden = count == .zero
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let categoryName = viewModel.categories[indexPath.row].categoryName
        let checkMarkIsHidden = viewModel.selectedCategory?.categoryName != categoryName
        let startIndex = indexPath.row == viewModel.categories.startIndex
        let endIndex = indexPath.row == viewModel.categories.count - 1
        
        cell.configureCell(categoryName: categoryName,
                           checkMarkIsHidden: checkMarkIsHidden,
                           startIndexCheck: startIndex,
                           endIndexCheck: endIndex)
        
        return cell
    }
}

    //MARK: UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        let checkProperty = false
        cell.checkMarkSetup(checkProperty: checkProperty)
        
        let selectedCategoryName = cell.getCelltext()
        viewModel.selectCategory(with: selectedCategoryName)
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        let checkProperty = true
        cell.checkMarkSetup(checkProperty: checkProperty)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let category = viewModel.categories[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: self.contextMenuChangeText) { [weak self] _ in
                    guard let self else { return }
                    let creationViewController = CategoryCreatorViewController(categoryEvent: .editing)
                    creationViewController.editableCategory = category
                    self.present(creationViewController, animated: true)
                },
                UIAction(title: self.contextMenuDeleteText, attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.categoryDeleteAlert(category: category)
                }
            ])
        })
    }
}

    //MARK: TrackerCategoryStoreDelegate

extension CategoryViewController: CategoryCreatorViewControllerDelegate {
    func createdCategory(_ category: TrackerCategory) {
        viewModel.selectCategory(with: category.categoryName)
        viewModel.selectedCategory(category)
    }
}
