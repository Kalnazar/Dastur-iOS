//
//  OnboardingViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        slides = [
            OnboardingSlide(title: "Its a Big World Out There, Go Explore!", image: "welcome-bg-1"),
            OnboardingSlide(title: "Explore the Kazakhstan.", image: "welcome-bg-2"),
            OnboardingSlide(title: "Get to know interesting Traditions & Cultures!", image: "welcome-bg-3")
        ]
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setup(slides[indexPath.row], currentPage: currentPage, slidesCount: slides.count)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
        let cell = OnboardingCollectionViewCell()
        print(cell.currentPage)
    }
}

extension OnboardingViewController: DelegatePageControl {
    func moveToController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "WelcomeNC") as! UINavigationController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func scrollToItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func initializationCurrentPage(index: Int) {
        self.currentPage = index
    }
}
