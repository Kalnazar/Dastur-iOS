//
//  CategoryCollectionViewCell.swift
//  Dastur
//
//  Created by Саят Калназар on 27.05.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var amountOfTraditions: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    private func update() {
        typeImageView.cornerRadius = typeImageView.frame.size.width / 2
        typeImageView.clipsToBounds = true
        typeImageView.layer.masksToBounds = true
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.contentView.layer.borderColor = UIColor(named: "AppGray")?.cgColor ?? UIColor.black.cgColor
        self.contentView.layer.borderWidth = 1.0
        
        let margin: CGFloat = 5.0
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }
    
    public func configure(image: String, title: String, amount: Int) {
        typeImageView.image = UIImage(named: image)
        typeName.text = title
        amountOfTraditions.text = "\(amount) Traditions"
    }
}
