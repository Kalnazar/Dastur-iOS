//
//  SignInViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        Core.shared.setIsUserSignedIn(isSigned: true)
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as! MainTabBarViewController
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: true)
    }
}
