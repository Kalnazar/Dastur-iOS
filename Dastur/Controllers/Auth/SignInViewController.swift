//
//  SignInViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        guard let email = emailField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
                password.count >= 6 else {
            present(Service.shared.createAlertController(title: "Error", message: "Enter all data"), animated: true)
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard authResult != nil, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            
            let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
            let tabBar = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as! MainTabBarViewController
            tabBar.modalPresentationStyle = .fullScreen
            strongSelf.present(tabBar, animated: true)
        }
    }
}

//Core.shared.setIsUserSignedIn(isSigned: true)
