//
//  MainTabBarViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    static let identifier = "MainTabBarViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetup()
    }
    
    func tabBarSetup() {
        let homeScreen = UINavigationController(rootViewController: HomeViewController())
        let categoriesScreen = UINavigationController(rootViewController: CategoriesViewController())
        let favoritesScreen = UINavigationController(rootViewController: FavoritesViewController())
        let profileScreen = UINavigationController(rootViewController: ProfileViewController())
                
        tabBar.tintColor = .label
        setViewControllers([homeScreen, categoriesScreen, favoritesScreen, profileScreen], animated: true)
    }
}
