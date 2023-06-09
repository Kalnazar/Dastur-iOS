//
//  SearchResultsViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 27.05.2023.
//

import UIKit
import JGProgressHUD

protocol SearchResultsDelegate {
    func itemPressed(_ tradition: TraditionModel)
}

class SearchResultsViewController: UIViewController {
    
    public var results = [[String: String]]()
    public let spinner = JGProgressHUD(style: .dark)
    var delegate: SearchResultsDelegate?

    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TraditionCardCollectionViewCell.self, forCellWithReuseIdentifier: TraditionCardCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(named: "AppClicked")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let strongSelf = self else { return }
                cell.contentView.backgroundColor = nil
                let results = strongSelf.results[indexPath.row]
                strongSelf.delegate?.itemPressed(TraditionModel(name: results["name"]!, imageName: results["image_name"]!, description: results["description"]!, rating: results["rating"]!, typeID: results["typeId"]!))
            }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TraditionCardCollectionViewCell.identifier, for: indexPath) as? TraditionCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        let result = results[indexPath.row]
        cell.configure(TraditionViewModel(name: result["name"]!, image: result["image_name"]!, rating: result["rating"]!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width - 20
        let itemHeight = 220.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
