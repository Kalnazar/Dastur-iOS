//
//  MainTabBarViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    
    static let identifier = "MainTabBarViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        DispatchQueue.main.async {
            self.validateAuth()
        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeScreen = storyboard.instantiateViewController(withIdentifier: WelcomeViewController.identifier) as! WelcomeViewController
            welcomeScreen.modalTransitionStyle = .crossDissolve
            welcomeScreen.modalPresentationStyle = .overFullScreen
            present(welcomeScreen, animated: true)
        }
    }
}
