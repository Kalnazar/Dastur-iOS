//
//  HomeHeaderUIView.swift
//  Dastur
//
//  Created by Саят Калназар on 30.05.2023.
//

import UIKit

class HomeHeaderUIView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Step into the world of nomadic traditions"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.alpha = 0.85
        label.textColor = .white
        return label
    }()
    
    private let homeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(homeImageView)
        addGradient()
        addSubview(headerLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let headerLabelConstraints = [
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(headerLabelConstraints)
    }
    
    public func configure(with image: String) {
        let image = UIImage(named: image)
        homeImageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
