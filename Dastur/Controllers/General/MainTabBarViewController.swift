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
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let strongSelf = self else { return }
                let welcomeScreen = strongSelf.storyboard?.instantiateViewController(withIdentifier: "WelcomNavigationController") as! UINavigationController
                welcomeScreen.modalPresentationStyle = .fullScreen
                strongSelf.present(welcomeScreen, animated: true)
            }
        }
    }
}
