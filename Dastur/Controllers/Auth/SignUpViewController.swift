//
//  SignUpViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let username = usernameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !username.isEmpty,
                !email.isEmpty,
                !password.isEmpty,
                password.count >= 6 else {
            present(Service.shared.createAlertController(title: "Error", message: "Enter all data"), animated: true)
            return
        }
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                strongSelf.present(Service.shared.createAlertController(title: "", message: "Looks like a user account for that email address already exists"), animated: true)
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: User(username: username, email: email))
                
                let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
                let tabBar = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as! MainTabBarViewController
                tabBar.modalPresentationStyle = .fullScreen
                strongSelf.present(tabBar, animated: true)
            }
        }
    }
}
