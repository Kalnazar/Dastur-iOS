//
//  CategoriesViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var types = [[String: String]]()
    private var typesFetched = false
    
    private var traditions = [[String: String]]()
    private var hasFetched = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .label
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        if !typesFetched {
            getTypes()
        }
    }
    
    private func getTypes() {
        spinner.show(in: view)
        DatabaseManager.shared.getAllData(from: "types", completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let types):
                DispatchQueue.main.async {
                    strongSelf.types = types
                    strongSelf.typesFetched = true
                    strongSelf.collectionView.reloadData()
                    strongSelf.spinner.dismiss()
                }
            case .failure(let error):
                print("Failed to get data: \(error)")
            }
        })
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let type = types[indexPath.row]
        cell.configure(image: "default", title: type["name"]!, amount: types.count)
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

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
        }
        resultsController.results.removeAll()
        resultsController.spinner.show(in: view)
        searchFrom(query: query)
    }
    
    private func searchFrom(query: String) {
        if hasFetched {
            filterTraditions(with: query)
        } else {
            DatabaseManager.shared.getAllData(from: "traditions", completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let collection):
                    print(collection)
                    strongSelf.hasFetched = true
                    strongSelf.traditions = collection
                    strongSelf.filterTraditions(with: query)
                case .failure(let error):
                    print("Failed to get data: \(error)")
                }
            })
        }
    }
    
    private func filterTraditions(with query: String) {
        guard hasFetched else {
            return
        }
        let results: [[String: String]] = traditions.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(query.lowercased())
        })
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.results = results
        DispatchQueue.main.async {
            resultsController.collectionView.reloadData()
            resultsController.spinner.dismiss()
        }
    }
}
