//
//  WelcomeViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    static let identifier = "WelcomeViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        navigationController?.navigationBar.tintColor = .white
    }
}
