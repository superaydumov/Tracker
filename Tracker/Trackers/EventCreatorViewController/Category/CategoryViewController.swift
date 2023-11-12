//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 09.10.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Computed properties
    
    private lazy var topLabel: UILabel = {
       let topLabel = UILabel()
        topLabel.text = "Категория"
        topLabel.textColor = .trackerBlack
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
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
        plugLabel.text = "Привычки и события можно\nобъединять по смыслу"
        plugLabel.numberOfLines = 2
        plugLabel.textAlignment = .center
        plugLabel.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return plugLabel
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle("Добавить категорию", for: .normal)
        categoryButton.setTitleColor(.trackerWhite, for: .normal)
        categoryButton.backgroundColor = .trackerBlack
        categoryButton.layer.cornerRadius = 16
        categoryButton.addTarget(self, action: #selector(createCategoryButtonDidTap(sender:)), for: .touchUpInside)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return categoryButton
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
        
        view.addSubview(plugView)
        plugView.addSubview(plugImageView)
        plugView.addSubview(plugLabel)
        
        view.addSubview(createCategoryButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
    
    // MARK: - Obj-C methods
    
    @objc func createCategoryButtonDidTap(sender: AnyObject) {
        let creationViewController = CategoryCreationViewController()
        present(creationViewController, animated: true)
    }
}
