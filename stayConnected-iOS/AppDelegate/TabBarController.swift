//
//  TabBarController.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomTabBar()
        setupTabBarController()
    }
    
    private func setupCustomTabBar() {
        self.tabBar.tintColor = .primaryViolet
        self.tabBar.unselectedItemTintColor = .primaryGray
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.primaryWhite
 
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    private func setupTabBarController() {
        let feedVC = configureTab(
            icon: "home", 
            title: "Home",
            vc: FeedVC()
        )
        
        let leaderboardVC = configureTab(
            icon: "trophy",
            title: "Leaderboard",
            vc: LeaderBoardVC()
        )
        
        let profileVC = configureTab(
            icon: "profile",
            title: "Profile",
            vc: ProfileVC()
        )
        
        self.setViewControllers([feedVC, leaderboardVC, profileVC], animated: true)
    }
    
    private func configureTab(icon: String, title: String, vc: UIViewController) -> UINavigationController {
        let tab = UINavigationController(rootViewController: vc)
        tab.tabBarItem.image = UIImage(named: icon)
        tab.tabBarItem.title = title
        return tab
    }
}
