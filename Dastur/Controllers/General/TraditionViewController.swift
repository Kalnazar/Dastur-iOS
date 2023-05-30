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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    
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
    
    public func configure(name: String) {
        self.name.text = name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    @IBAction func likePressed(_ sender: UIButton) {
        isLiked.toggle()
        likeButton.isSelected = isLiked
    }
    
    private func setUpView() {
        imageView.layer.addSublayer(gradientLayer)
        
        likeButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        likeButton.tintColor = .clear
    }
}
