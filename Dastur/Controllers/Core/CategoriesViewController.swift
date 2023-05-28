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
    
    private let types: [String] = ["Традиции приема гостей", "Свадебные традиции", "Обычаи, связанные с детьми", "Казахские игры и развлечения", "Традиции помощи ближнему", "Айтыс"]
    
    private var traditions = [[String: String]]()
    private var hasFetched = false
    
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
        let itemWidth = UIScreen.main.bounds.width - 20
        let itemHeight = 110.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension CategoriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
        }
        resultsController.results.removeAll()
        self.searchFrom(query: query)
    }
    
    private func searchFrom(query: String) {
        // check if array has firebase results
        if hasFetched {
            // if it does: filter
            filterTraditions(with: query)
        } else {
            // if not, fetch then filter
            DatabaseManager.shared.getAllData(from: "users", completion: { [weak self] result in
                switch result {
                case .success(let collection):
                    self?.hasFetched = true
                    self?.traditions = collection
                    self?.filterTraditions(with: query)
                case .failure(let error):
                    print("Failed to get data: \(error)")
                }
            })
        }
    }
    
    private func filterTraditions(with query: String) {
        // update the UI: either show results or show no results label
        guard hasFetched else {
            return
        }
        let results: [[String: String]] = self.traditions.filter({
            guard let name = $0["username"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(query.lowercased())
        })
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.results = results
        resultsController.collectionView.reloadData()
    }
}
