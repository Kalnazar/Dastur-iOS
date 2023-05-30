//
//  TraditionViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 30.05.2023.
//

import UIKit

class TraditionViewController: UIViewController {
    
    static let identifier = "TraditionViewController"
    private var isLiked = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    public func configure(_ tradition: TraditionModel) {
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
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    @IBAction func likePressed(_ sender: UIButton) {
        isLiked.toggle()
        likeButton.isSelected = isLiked
        DatabaseManager.shared.addToFavourites(id: nameLabel.text!)
    }
    
    private func setUpView() {
        imageView.layer.addSublayer(gradientLayer)
        
        likeButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        likeButton.tintColor = .clear
    }
}
