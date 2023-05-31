//
//  SignUpViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let username = usernameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !username.isEmpty,
                !email.isEmpty,
                !password.isEmpty,
                password.count >= 6 else {
            present(Service.createAlertController(title: "Error", message: "Enter all data"), animated: true)
            return
        }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                let alertController = Service.createAlertController(title: "Error", message: "Looks like a user account for that email address already exists")
                strongSelf.present(alertController, animated: true)
                return
            }
            
            Service.signUpUser(email: email, password: password, username: username) {
                strongSelf.navigationController?.dismiss(animated: true)
            } onError: { error in
                let alertController = Service.createAlertController(title: "Error", message: error!.localizedDescription)
                strongSelf.present(alertController, animated: true)
            }

        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
