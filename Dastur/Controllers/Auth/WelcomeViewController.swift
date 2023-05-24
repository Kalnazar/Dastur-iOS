//
//  WelcomeViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    static let identifier = "WelcomeViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else if Core.shared.isUserSignedIn() {
            let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
            let tabBar = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as! MainTabBarViewController
            tabBar.modalTransitionStyle = .crossDissolve
            tabBar.modalPresentationStyle = .overFullScreen
            self.present(tabBar, animated: true)
        }
    }
}
