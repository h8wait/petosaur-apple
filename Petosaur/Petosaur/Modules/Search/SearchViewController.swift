//
//  SearchViewController.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController, SearchViewProtocol {
    
    private var podcasts: [PodcastEntity] = []
    private var loading = false
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for podcasts"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.allowsSelection = false
        view.register(PodcastCell.self, forCellReuseIdentifier: tableViewCellId)
        view.register(LoadingCell.self, forCellReuseIdentifier: tableViewLoadingCellId)
        return view
    }()
    private let tableViewCellId = "podcastCell"
    private let tableViewLoadingCellId = "loadingCell"
    
    private lazy var errorImage = UIImageView()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            errorImage,
            errorLabel
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    var presenter: SearchPresenterProtocol?
    
    // MARK: Public methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Podcasts"
        
        configureNavigationBar()
        configureTableView()
        
        // Notify logic
        presenter?.viewDidLoad()
    }
    
    func prepareForSearchResult() {
        tableView.isHidden = false
        errorView.removeFromSuperview()
        
        podcasts = []
        loading = true
        tableView.reloadData()
    }
    
    func showPodcasts(searchedItems: [PodcastEntity]) {
        podcasts = searchedItems
        loading = false
        tableView.reloadData()
    }
    
    func showPodcasts(fetchedItems: [PodcastEntity]) {
        podcasts.append(contentsOf: fetchedItems)
        loading = false
        tableView.reloadData()
    }
    
    func showLoader() {
        guard loading == false else {
            return
        }
        
        loading = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func hideLoader() {
        guard loading == true else {
            return
        }
        
        loading = false
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func showEmptyResult() {
        configureErrorView(text: "No results", imageName: "NoData")
    }
    
    func showError(text: String) {
        configureErrorView(text: text, imageName: "NoConnection")
    }
    
    // MARK: Private methods -
    
    private func configureNavigationBar() {
        // Button to configure search parameters
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(configButtonClicked))
        navigationItem.rightBarButtonItem = button
        
        // Add search to navigation bar
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureErrorView(text: String?, imageName: String) {
        tableView.isHidden = true
        
        errorLabel.text = text
        errorImage.image = UIImage(named: imageName)
        
        view.addSubview(errorView)
        
        errorImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
        errorView.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc private func configButtonClicked() {
        presenter?.configureSearchDidTap()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return podcasts.count
        case 1 where loading:
            return 1 // Loading cell section
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? PodcastCell {
            if podcasts.indices.contains(indexPath.row) {
                let entity = podcasts[indexPath.row]
                cell.configure(title: entity.title,
                               publisher: entity.publisher,
                               imageURL: entity.imageURL)
            }
            return cell
        } else if indexPath.section == 1,
                  let cell = tableView.dequeueReusableCell(withIdentifier: tableViewLoadingCellId, for: indexPath) as? LoadingCell {
            cell.startAnimating()
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0,
           indexPath.row == podcasts.count - 2 {
            presenter?.beginFetch()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.searchTextDidUpdate(text: searchController.searchBar.text)
    }
}
