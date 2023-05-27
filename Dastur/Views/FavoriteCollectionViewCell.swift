//
//  FavoriteCollectionViewCell.swift
//  Dastur
//
//  Created by Саят Калназар on 27.05.2023.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"
    
    @IBOutlet weak var traditionImageView: UIImageView!
    @IBOutlet weak var traditionName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor(named: "AppGray")?.cgColor
    }
    
    public func configure(image: String, tradition: String) {
        traditionImageView.image = UIImage(named: image)
        traditionName.text = tradition
    }
}
