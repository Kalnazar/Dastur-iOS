//
//  SignInViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

protocol SignInViewControllerDelegate: AnyObject {
    func signInViewControllerDidSignIn(_ viewController: SignInViewController)
}

class SignInViewController: UIViewController {

    static let identifier = "SignInViewController"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let spinner = JGProgressHUD(style: .dark)
    weak var delegate: SignInViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        guard let email = emailField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
                password.count >= 6 else {
            present(Service.createAlertController(title: "Error", message: "Enter all data"), animated: true)
            return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard authResult != nil, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            
            UserDefaults.standard.set(email, forKey: "userEmailKey")
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
