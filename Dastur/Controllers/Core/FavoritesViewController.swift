//
//  FavoritesViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import JGProgressHUD
import Firebase

class FavoritesViewController: UIViewController {

    private var favourites = [[String: String]]()
    private let spinner = JGProgressHUD(style: .dark)
    private var favouritesRef: DatabaseReference?
    private var favouritesHandle: DatabaseHandle?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TraditionCardCollectionViewCell.self, forCellWithReuseIdentifier: TraditionCardCollectionViewCell.identifier)
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchFavourites()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFavourites()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeFavouritesObserver()
    }
    
    private func fetchFavourites() {
        spinner.show(in: view)
        DatabaseManager.shared.getTraditionsForFavorites { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let favourites):
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
    
    private func observeFavourites() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        favouritesRef = Database.database().reference().child("favourites").child(uid)
        favouritesHandle = favouritesRef?.observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if snapshot.value as? [String] != nil{
                strongSelf.fetchFavourites()
            }
        })
    }
    
    private func removeFavouritesObserver() {
        favouritesRef?.removeObserver(withHandle: favouritesHandle!)
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
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth - 20
        let itemHeight: CGFloat = 220.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
