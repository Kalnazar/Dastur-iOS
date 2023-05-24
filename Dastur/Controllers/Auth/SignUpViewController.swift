//
//  SignUpViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let username = usernameField.text, let email = emailField.text, let password = passwordField.text, !username.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            print("Hello")
            present(Service.shared.createAlertController(title: "Error", message: "Enter all data"), animated: true)
            return
        }
    }
}
