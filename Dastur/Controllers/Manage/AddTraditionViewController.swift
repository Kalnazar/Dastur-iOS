//
//  AddTraditionViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 31.05.2023.
//

import UIKit
import JGProgressHUD

class AddTraditionViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    private var types = [[String: String]]()
    private var typesFetched = false
    
    @IBOutlet weak var traditionImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var pickerViewType: UIPickerView!
    @IBOutlet weak var titleImage: UILabel!
    
    private var selectedType: String?
    private var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        if typesFetched != true {
            getTypes()
        }
    }

    @IBAction func createTraditionPressed(_ sender: UIButton) {
        if let name = nameField.text,
           let desc = descriptionText,
           !name.isEmpty,
           traditionImage.image != nil,
           !desc.isEmpty,
           selectedType != nil {
            guard let imageName = nameField.text?.replacingOccurrences(of: " ", with: "_").lowercased() else { return }
            let filename = imageName + "_tradition.png"
            uploadImage(filename: filename)
            DatabaseManager.shared.uploadTradition(with: TraditionModel(name: name, imageName: filename, description: desc, rating: "0", typeID: selectedType!))
            dismiss(animated: true)
        } else {
            let alert = Service.createAlertController(title: "Error", message: "Enter all data")
            present(alert, animated: true)
        }
    }
    
    private func uploadImage(filename: String) {
        guard let image = traditionImage.image,
              let data = image.pngData() else {
            return
        }
        StorageManager.shared.uploadTraditionImage(with: data, filename: filename)
    }
    
    private func getTypes() {
        spinner.show(in: view)
        DatabaseManager.shared.getAllData(from: "types", completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let types):
                DispatchQueue.main.async {
                    strongSelf.types = types
                    strongSelf.typesFetched = true
                    strongSelf.pickerViewType.reloadAllComponents()
                    strongSelf.spinner.dismiss()
                }
            case .failure(let error):
                print("Failed to get data: \(error)")
            }
        })
    }
    
    @objc private func didPressChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    private func setView() {
        nameField.layer.masksToBounds = true
        nameField.layer.borderWidth = 1.0
        nameField.layer.cornerRadius = 5.0
        nameField.layer.borderColor = UIColor.label.cgColor
        
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.label.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.delegate = self
        
        pickerViewType.delegate = self
        pickerViewType.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressChangeProfilePic))
        traditionImage.addGestureRecognizer(gesture)
    }
}

extension AddTraditionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionText = descriptionTextView.text
    }
}

extension AddTraditionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]["name"]!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        types.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension AddTraditionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Tradition Image", message: "How would you like to select an image", preferredStyle: .actionSheet)
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
        self.traditionImage.image = selectedImage
        titleImage.isHidden = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
