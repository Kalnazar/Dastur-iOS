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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        imageSetup()
        if Core.shared.DoesUserHaveProfilePicture() {
            print("User has an image")
            getImage()
        }
    }
    
    private func uploadImage() {
        guard let image = self.imageView.image,
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
    
    private func getImage() {
        guard let user = FirebaseAuth.Auth.auth().currentUser else {
            print ("Failed to get a user")
            return
        }
        let userData = User(username: user.email!, email: user.email!)
        
        let filename = userData.profilePictureFileName
        StorageManager.shared.getProfilePicture(filename: filename) { [weak self] results in
            guard let strongSelf = self else {
                return
            }
            switch results {
            case .success(let data):
                Core.shared.setDoesUserHaveProfilePicture()
                strongSelf.imageView.image = UIImage(data: data)
            case .failure(let error):
                print("Failed while trying to get an image\(error)")
            }
        }
    }
    
    @objc private func didPressChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    private func imageSetup() {
        imageView.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                strongSelf.dismiss(animated: true)
            } catch {
                print("Failed to log out")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}

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
