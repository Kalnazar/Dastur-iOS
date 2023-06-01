//
//  HomeViewController.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

enum Sections: Int {
    case Guest = 0
    case Wedding = 1
    case Children = 2
    case Entertainment = 3
    case Help = 4
    case Music = 5
}

class HomeViewController: UIViewController {
    
    private var types = [[String: String]]()
    private var typesFetched = false
    private let spinner = JGProgressHUD(style: .dark)
    private var headerView: HomeHeaderUIView?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureNavbar()
        
        headerView = HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        headerView?.configure(with: "culture")
        tableView.tableHeaderView = headerView
        
        fetchData()
    }
    
    private func fetchData() {
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
                    strongSelf.tableView.reloadData()
                    strongSelf.spinner.dismiss()
                }
            case .failure(let error):
                print("Failed to get data: \(error)")
            }
        })
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dastur", style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "network"), style: .done, target: self, action: #selector(rightBarButtonItemTapped))
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc func rightBarButtonItemTapped() {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        
        let id = types[indexPath.section]["id"] ?? ""
        DatabaseManager.shared.getDataOfType(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                cell.configure(data)
                cell.delegate = self
            case .failure(_):
                print("Failed to get data for specific id: \(id)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return types[section]["name"]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.contentView.backgroundColor = .systemBackground
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension HomeViewController: CustomCellDelegate {
    
    func didSelectItemAtIndex(tradition: TraditionModel) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: TraditionViewController.identifier) as? TraditionViewController else {
            return
        }
        vc.configure(tradition)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
}
