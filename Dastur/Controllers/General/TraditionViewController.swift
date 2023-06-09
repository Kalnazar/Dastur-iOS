//
//  TraditionViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 30.05.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class TraditionViewController: UIViewController {
    
    static let identifier = "TraditionViewController"
    private var isLiked = false
    private let spinner = JGProgressHUD(style: .dark)
    
    private let heartFillIcon = "heart.fill"
    private let heartIcon = "heart"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var viewDetail: UIView!
    private var traditionId: String?
    
    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        checkIfLiked()
    }
    
    public func configure(_ tradition: TraditionModel) {
        spinner.show(in: view)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let path = "traditions/" + tradition.imageName
            StorageManager.shared.downloadURL(for: path) { result in
                switch result {
                case .success(let url):
                    StorageManager.shared.downloadImage(imageView: strongSelf.imageView, url: url)
                case .failure(let error):
                    strongSelf.imageView.image = UIImage(named: "culture")
                    print("Failed: \(error)")
                }
            }
            strongSelf.nameLabel.text = tradition.name
            strongSelf.rating.text = "Rating \(tradition.rating)"
            strongSelf.descriptionTextView.text = tradition.description
            strongSelf.traditionId = tradition.name
            strongSelf.spinner.dismiss()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    @IBAction func likePressed(_ sender: UIButton) {
        isLiked.toggle()
        likeButton.isSelected = isLiked
        likeButton.setImage(UIImage(systemName: isLiked ? heartFillIcon : heartIcon), for: .normal)
        
        if isLiked {
            DatabaseManager.shared.addToFavourites(id: traditionId!)
        } else {
            DatabaseManager.shared.removeFromFavourites(id: traditionId!)
        }
    }
    
    private func checkIfLiked() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("favourites").child(uid).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if let favourites = snapshot.value as? [String] {
                guard let traditionId = strongSelf.traditionId else { return }
                if favourites.contains(traditionId) {
                    print("Liked")
                    strongSelf.isLiked = true
                    strongSelf.likeButton.isSelected = true
                    strongSelf.likeButton.setImage(UIImage(systemName: strongSelf.heartFillIcon), for: .normal)
                }
            }
        })
    }
    
    private func setUpView() {
        imageView.layer.addSublayer(gradientLayer)
        likeButton.tintColor = .clear
        viewDetail.backgroundColor = .systemBackground
    }
}
