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
    
    public func configure(image: String, tradition: String) {
        traditionImageView.image = UIImage(named: image)
        traditionName.text = tradition
    }
}
