//
//  SignInViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as! MainTabBarViewController
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}
