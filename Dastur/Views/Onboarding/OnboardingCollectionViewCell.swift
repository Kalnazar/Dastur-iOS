//
//  OnboardingCollectionViewCell.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

protocol DelegatePageControl {
    func moveToController()
    func scrollToItem(indexPath: IndexPath)
    func initializationCurrentPage(index: Int)
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = "OnboardingCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slideLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    var delegate: DelegatePageControl?
    
    func setup(_ slide: OnboardingSlide, currentPage: Int, slidesCount: Int) {
        imageView.image = UIImage(named: slide.image)
        slideLabel.text = slide.title
        pageControl.numberOfPages = slidesCount
        self.currentPage = currentPage
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentPage == pageControl.numberOfPages - 1 {
            self.delegate?.moveToController()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.delegate?.scrollToItem(indexPath: indexPath)
            self.delegate?.initializationCurrentPage(index: currentPage)
        }
    }
}
