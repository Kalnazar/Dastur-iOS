//
//  FavoritesViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import JGProgressHUD

class FavoritesViewController: UIViewController {

    private var favourites = [[String: String]]()
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchFavourites()
    }
    
    private func fetchFavourites() {
        spinner.show(in: view)
        DatabaseManager.shared.getTraditionsForFavorites { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let favourites):
                print(favourites)
                DispatchQueue.main.async {
                    strongSelf.favourites = favourites
                    strongSelf.collectionView.reloadData()
                    strongSelf.spinner.dismiss()
                }
            case .failure(let error):
                print("Failed to get favourites: \(error)")
            }
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(named: "AppClicked")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let strongSelf = self else { return }
                guard let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: TraditionViewController.identifier) as? TraditionViewController else {
                    return
                }
                let favourite = strongSelf.favourites[indexPath.row]
                vc.configure(TraditionModel(name: favourite["name"]!, imageName: favourite["image_name"]!, description: favourite["description"]!, rating: favourite["rating"]!, type: favourite["typeId"]!))
                vc.modalPresentationStyle = .formSheet
                strongSelf.present(vc, animated: true)
                cell.contentView.backgroundColor = nil
            }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TraditionCardCollectionViewCell.identifier, for: indexPath) as? TraditionCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        let favourite = favourites[indexPath.row]
        cell.configure(TraditionViewModel(name: favourite["name"]!, image: favourite["image_name"]!, rating: favourite["rating"]!))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width - 20
        let itemHeight = 220.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
