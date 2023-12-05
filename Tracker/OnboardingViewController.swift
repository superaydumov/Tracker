//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 10.11.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    var checkProperty: Bool?
    
    private let buttonTitleText = NSLocalizedString("buttonTitle", comment: "Onboarding button label text")
    private let blueLabelText = NSLocalizedString("blueLabel", comment: "Onboarding blueLabel text")
    private let redLabelText = NSLocalizedString("redLabel", comment: "Onboarding redLabel text")
    
    private struct Keys {
        static let blueImage = "blueBackground.png"
        static let redImage = "redBackground.png"
    }
    
    //MARK: ComputedProperties
    
    private lazy var pages: [UIViewController] = {
        return [blueViewController, redViewController]
    }()
    
    private lazy var blueViewController: UIViewController = {
        let bluePage = UIViewController()
        let blueImage = Keys.blueImage
        bluePage.view.addBackground(image: blueImage)
        
        return bluePage
    }()
    
    private lazy var redViewController: UIViewController = {
        let redPage = UIViewController()
        let redImage = Keys.redImage
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
        button.setTitle(buttonTitleText, for: .normal)
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
        label.text = blueLabelText
        label.numberOfLines = 2
        label.textColor = .trackerBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = redLabelText
        label.numberOfLines = 2
        label.textColor = .trackerBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var blueLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var redLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
        
        blueViewController.view.addSubview(blueLogoView)
        redViewController.view.addSubview(redLogoView)
        blueViewController.view.addSubview(blueLabel)
        redViewController.view.addSubview(redLabel)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            blueLogoView.topAnchor.constraint(equalTo: blueViewController.view.topAnchor, constant: 80),
            blueLogoView.centerXAnchor.constraint(equalTo: blueViewController.view.centerXAnchor),
            blueLogoView.heightAnchor.constraint(equalToConstant: 80),
            blueLogoView.widthAnchor.constraint(equalToConstant: 80),
            
            redLogoView.topAnchor.constraint(equalTo: redViewController.view.topAnchor, constant: 80),
            redLogoView.centerXAnchor.constraint(equalTo: redViewController.view.centerXAnchor),
            redLogoView.heightAnchor.constraint(equalToConstant: 80),
            redLogoView.widthAnchor.constraint(equalToConstant: 80),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blueLabel.leadingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            blueLabel.trailingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            blueLabel.centerXAnchor.constraint(equalTo: blueViewController.view.centerXAnchor),
            blueLabel.topAnchor.constraint(equalTo: blueLogoView.bottomAnchor, constant: 35),
            
            redLabel.leadingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            redLabel.trailingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            redLabel.centerXAnchor.constraint(equalTo: redViewController.view.centerXAnchor),
            redLabel.topAnchor.constraint(equalTo: redLogoView.bottomAnchor, constant: 35)
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
