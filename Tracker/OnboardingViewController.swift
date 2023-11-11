//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.11.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    var checkProperty: Bool?
    
    //MARK: ComputedProperties
    
    private lazy var pages: [UIViewController] = {
        return [blueViewController, redViewController]
    }()
    
    private lazy var blueViewController: UIViewController = {
        let bluePage = UIViewController()
        let blueImage = "blueBackground.png"
        bluePage.view.addBackground(image: blueImage)
        
        return bluePage
    }()
    
    private lazy var redViewController: UIViewController = {
        let redPage = UIViewController()
        let redImage = "redBackground.png"
        redPage.view.addBackground(image: redImage)
        
        return redPage
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = .zero
        
        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTap(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Отслеживайте только то, что хотите"
        label.numberOfLines = 2
        label.textColor = .trackerBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Даже если это не литры воды и йога"
        label.numberOfLines = 2
        label.textColor = .trackerBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        addSubviews()
        constraintsSetup()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    //MARK: Private methods
    
    private func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(button)
        blueViewController.view.addSubview(blueLabel)
        redViewController.view.addSubview(redLabel)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blueLabel.leadingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            blueLabel.trailingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            blueLabel.centerXAnchor.constraint(equalTo: blueViewController.view.centerXAnchor),
            blueLabel.bottomAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            redLabel.leadingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            redLabel.trailingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            redLabel.centerXAnchor.constraint(equalTo: redViewController.view.centerXAnchor),
            redLabel.bottomAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
        ])
    }
    
    //MARK: objc methods
    
    @objc private func buttonDidTap(sender: AnyObject) {
        guard let window = UIApplication.shared.windows.first else {
            return assertionFailure("Invalid configuration")
        }
        window.rootViewController = TabBarViewController()
        
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
    }
}

    //MARK: UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerindex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerindex - 1

        guard previousIndex >= 0 else { return pages.last }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerindex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerindex + 1

        guard nextIndex < pages.count else { return pages.first }

        return pages[nextIndex]
    }
}

    //MARK: UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
