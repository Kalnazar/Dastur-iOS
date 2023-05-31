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
    
    private var traditions = [[String: String]]()
    private var hasFetched = false
    
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
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
        }
        resultsController.delegate = self
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
    
    func itemPressed(_ tradition: TraditionModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(identifier: TraditionViewController.identifier) as! TraditionViewController
            vc.configure(tradition)
            vc.modalPresentationStyle = .formSheet
            self?.present(vc, animated: true)
        }
    }
}
