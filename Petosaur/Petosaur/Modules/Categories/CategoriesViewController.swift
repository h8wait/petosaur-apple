//
//  CategoriesViewController.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import UIKit

final class CategoriesViewController: UIViewController, CategoriesViewProtocol {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableViewCellId = "categoryCell"
    
    private var categories = [String]()
    
    var presenter: CategoriesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
        
        presenter?.viewDidLoad()
    }
    
    func showCategories(items: [String]) {
        categories = items
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        if categories.indices.contains(indexPath.row) {
            cell.textLabel?.text = categories[indexPath.row]
        }
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories.indices.contains(indexPath.row) {
            presenter?.categoryDidTap(name: categories[indexPath.row])
        }
    }
}
