//
//  CategoriesViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .label
        return controller
    }()
    
    let types: [String] = ["Традиции приема гостей", "Свадебные традиции", "Обычаи, связанные с детьми", "Казахские игры и развлечения", "Традиции помощи ближнему", "Айтыс"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(named: "AppClicked")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cell.contentView.backgroundColor = nil
            }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        print(types[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: "default", title: types[indexPath.row], amount: types.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width - 40
        let itemHeight = 110.0
        return CGSize(width: UIScreen.main.bounds.width - 20, height: itemHeight)
    }
}

extension CategoriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
        }
    }
    
}
