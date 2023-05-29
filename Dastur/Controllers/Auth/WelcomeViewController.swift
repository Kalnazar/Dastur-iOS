//
//  WelcomeViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

protocol DismissWelcomeController {
    func dismissController()
}

class WelcomeViewController: UIViewController, DismissWelcomeController {
    
    static let identifier = "WelcomeViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Core.shared.isNewUser() {
            let vc = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        let vc = storyboard.instantiateViewController(withIdentifier: SignInViewController.identifier) as! SignInViewController
        vc.delegate = self

    }
    
    func dismissController() {
        print("Hello")
        navigationController?.dismiss(animated: true)
    }
}
