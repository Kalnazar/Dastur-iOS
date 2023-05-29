//
//  HomeViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class HomeViewController: UIViewController {
    
    private var types = [[String: String]]()
    private var typesFetched = false
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        if !typesFetched {
//            getTypes()
//        }
    }
    /*
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
    }*/
}
