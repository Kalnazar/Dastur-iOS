//
//  ProfileViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        imageSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didPressChangeProfilePic() {
        print("Change pic")
    }
    
    private func imageSetup() {
        imageView.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        Core.shared.setIsUserSignedIn(isSigned: false)
        self.dismiss(animated: true)
    }
}
