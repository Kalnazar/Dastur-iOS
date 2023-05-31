//
//  ProfileViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavbar()
        imageViewSetup()
        getInfo()
        profileImage()
        createButton.isHidden = true
    }
    
    @objc private func didPressChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func signOut() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            UserDefaults.standard.setValue(nil, forKey: "userEmailKey")
            UserDefaults.standard.setValue(nil, forKey: "userNameKey")
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let welcomeScreen = strongSelf.storyboard?.instantiateViewController(withIdentifier: "WelcomNavigationController") as! UINavigationController
                welcomeScreen.modalPresentationStyle = .fullScreen
                strongSelf.present(welcomeScreen, animated: true)
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let sceneDelegate = windowScene.delegate as? SceneDelegate,
                          let window = sceneDelegate.window else {
                        return
                    }
                    window.rootViewController = strongSelf.storyboard?.instantiateInitialViewController()
                    window.makeKeyAndVisible()
                }
            } catch {
                print("Failed to log out")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ManageNavigationController") as! UINavigationController
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
}

// MARK: - Profile View Setting

extension ProfileViewController {
    private func getInfo() {
        let defaults = UserDefaults.standard
        
        Service.getUserInfo { [weak self] in
            self?.usernameLabel.text = defaults.string(forKey: "userNameKey")
            if defaults.string(forKey: "userEmailKey") == "sayat@gmail.com" {
                self?.createButton.isHidden = false
            }
        } onError: { error in
            print(error!.localizedDescription)
        }
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(signOut))
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func profileImage() {
        guard let email = UserDefaults.standard.value(forKey: "userEmailKey") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                StorageManager.shared.downloadImage(imageView: (self?.imageView)!, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
    }
    
    private func uploadImage() {
        guard let image = imageView.image,
              let data = image.pngData() else {
            return
        }
        guard let user = FirebaseAuth.Auth.auth().currentUser else {
            print ("Failed to get a user")
            return
        }
        let userData = User(username: user.email!, email: user.email!)
        
        let filename = userData.profilePictureFileName
        StorageManager.shared.uploadProfilePicture(with: data, filename: filename) { results in
            switch results {
            case .success(let downloadUrl):
                Core.shared.setDoesUserHaveProfilePicture()
                print(downloadUrl)
            case .failure(let error):
                print("Storage manager error: \(error)")
            }
        }
    }
    
    private func imageViewSetup() {
        imageView.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
    }
}

// MARK: - Profile View ImagePicker

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.imageView.image = selectedImage
        uploadImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
