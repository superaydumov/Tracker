//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 06.10.2023.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private struct Keys {
        static let trackersTitle = "Трекеры"
        static let statisticTitle = "Статистика"
    }
    
    private struct imageKeys {
        static let trackersTabBarOn = UIImage(named: "trackersTabBar_On")
        static let trackersTabBarOff = UIImage(named: "trackersTabBar_Off")
        static let statisticTabBarOn = UIImage(named: "statistictabBar_On")
        static let statisticTabBarOff = UIImage(named: "statistictabBar_Off")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(title: Keys.trackersTitle, image: imageKeys.trackersTabBarOff, selectedImage: imageKeys.trackersTabBarOn)
        statisticViewController.tabBarItem = UITabBarItem(title: Keys.statisticTitle, image: imageKeys.statisticTabBarOff, selectedImage: imageKeys.statisticTabBarOn)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }
    
    private func tabBarSetup() {
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor
        tabBar.clipsToBounds = true
    }
}
