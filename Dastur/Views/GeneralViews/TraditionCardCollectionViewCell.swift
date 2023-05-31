//
//  SearchResultCollectionViewCell.swift
//  Dastur
//
//  Created by Саят Калназар on 27.05.2023.
//

import UIKit

class TraditionCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TraditionCardCollectionViewCell"
    
    private let traditionImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()
    
    private let traditionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Semibold", size: 16)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
    }
    
    public func configure(_ tradition: TraditionViewModel) {
        let path = "traditions/" + tradition.image
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                StorageManager.shared.downloadImage(imageView: self!.traditionImageView, url: url)
            case .failure(let error):
                self!.traditionImageView.image = UIImage(named: "default")
                print("Failed to get download url: \(error)")
            }
        }
        traditionName.text = tradition.name
        ratingLabel.text = tradition.rating
    }
    
    private func setupViews() {
        contentView.addSubview(traditionImageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(traditionName)
        labelsStackView.addArrangedSubview(ratingLabel)
        contentView.layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        let traditionImageViewConstraints = [
            traditionImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            traditionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            traditionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            traditionImageView.heightAnchor.constraint(equalToConstant: 170)
        ]
        
        let labelsStackViewConstraints = [
            labelsStackView.topAnchor.constraint(equalTo: traditionImageView.bottomAnchor, constant: 10),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(traditionImageViewConstraints)
        NSLayoutConstraint.activate(labelsStackViewConstraints)
        traditionName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ratingLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
