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
        tabBar.tintColor = .label
    }
    
    /*
    func tabBarSetup() {
        let homeScreen = UINavigationController(rootViewController: HomeViewController())
        let categoriesScreen = UINavigationController(rootViewController: CategoriesViewController())
        let favoritesScreen = UINavigationController(rootViewController: FavoritesViewController())
        let profileScreen = UINavigationController(rootViewController: ProfileViewController())
        
        homeScreen.tabBarItem.image = UIImage(systemName: "house")
        categoriesScreen.tabBarItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        favoritesScreen.tabBarItem.image = UIImage(systemName: "heart")
        profileScreen.tabBarItem.image = UIImage(systemName: "person")
        
        tabBar.tintColor = .label
        self.viewControllers = [homeScreen, categoriesScreen, favoritesScreen, profileScreen]
    }
    */
}
