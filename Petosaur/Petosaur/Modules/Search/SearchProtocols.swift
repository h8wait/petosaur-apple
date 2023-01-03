//
//  SearchProtocols.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import Foundation
import UIKit

protocol SearchModuleBuilderProtocol {
    
    func createSearchModule() -> UIViewController
}

// MARK: - View
protocol SearchViewProtocol: AnyObject {
    
    var presenter: SearchPresenterProtocol? { get set }
    
    func prepareForSearchResult()
    func showPodcasts(searchedItems: [PodcastEntity])
    func showPodcasts(fetchedItems: [PodcastEntity])
    func showLoader()
    func hideLoader()
    func showError(text: String)
    func showEmptyResult()
}

// MARK: - Interactor
protocol SearchInteractorProtocol: AnyObject {
    
    var presenter: SearchPresenterProtocol? { get set }
    
    func startSearch(text: String?, title: String?, categoryName: String?, page: UInt, limit: UInt)
    func startFetch(text: String?, title: String?, categoryName: String?, lastLoadedPage: UInt, limit: UInt)
}

// MARK: - Presenter
protocol SearchPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    
    func beginFetch()
    func searchTextDidUpdate(text: String?)
    func configureSearchDidTap()
    
    func searchDidStart()
    func searchDidResults(items: [PodcastEntity])
    func searchDidEmpty()
    func searchDidFailed()
    func searchDidComplete()
    
    func fetchDidResults(items: [PodcastEntity])
    func fetchDidFailed()
}

// MARK: - Router
protocol SearchRouterProtocol: AnyObject {
    
    func configureSearch(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol)
}
