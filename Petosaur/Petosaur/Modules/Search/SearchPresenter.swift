//
//  SearchPresenter.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import RxSwift

final class SearchPresenter: SearchPresenterProtocol {
    
    //MARK: State -
    private var searchText: String?
    private var searchTitle: String?
    private var searchCategoryName: String?
    private var currentPage: UInt = 1
    private let pageLimit: UInt = 10
    
    private var hasMoreResults = true
    
    private let bag = DisposeBag()
    private let textSubject = PublishSubject<String?>()
    private let configSubject = PublishSubject<ConfigurationEntity?>()
    
    weak private var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    private let router: SearchRouterProtocol
    
    init(view: SearchViewProtocol, interactor: SearchInteractorProtocol?, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        let convertedTextSubject = textSubject.filterByPrevious().map { $0 as AnyObject }
        let convertedConfigSubject = configSubject.map { $0 as AnyObject }
        
        Observable
            .of(convertedTextSubject, convertedConfigSubject)
            .merge()
            .do(onNext: { [weak self] _ in
                self?.view?.prepareForSearchResult()
            })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.startSearch()
            }
            .disposed(by: bag)
    }
    
    //MARK: Public methods -
    
    func viewDidLoad() {
        textSubject.onNext(searchText)
    }
    
    func configureSearchDidTap() {
        let config = ConfigurationEntity(categoryName: searchCategoryName, title: searchTitle)
        router.configureSearch(currentConfig: config, output: self)
    }
    
    //MARK: Search
    
    func searchTextDidUpdate(text: String?) {
        searchText = text
        textSubject.onNext(searchText)
    }
    
    func searchDidStart() {
        hasMoreResults = true
    }
    
    func searchDidResults(items: [PodcastEntity]) {
        // Search parameters was changed, this is new 10 items
        view?.showPodcasts(searchedItems: items)
    }
    
    func searchDidEmpty() {
        view?.showEmptyResult()
    }
    
    func searchDidFailed() {
        view?.showError(text: "Something went wrong, try again later")
    }
    
    func searchDidComplete() {
        hasMoreResults = false
    }
    
    //MARK: Fetch
    
    func beginFetch() {
        guard hasMoreResults else {
            return
        }
        
        view?.showLoader()
        startFetch()
    }
    
    func fetchDidResults(items: [PodcastEntity]) {
        currentPage += 1
        // Search parameters wasn't changed, this is next 10 items for append
        view?.showPodcasts(fetchedItems: items)
    }
    
    func fetchDidFailed() {
        view?.hideLoader()
    }
    
    //MARK: Private methods -
    
    private func startSearch() {
        currentPage = 1
        interactor?.startSearch(
            text: searchText,
            title: searchTitle,
            categoryName: searchCategoryName,
            page: currentPage,
            limit: pageLimit)
    }
    
    private func startFetch() {
        interactor?.startFetch(
            text: searchText,
            title: searchTitle,
            categoryName: searchCategoryName,
            lastLoadedPage: currentPage,
            limit: pageLimit)
    }
}

extension SearchPresenter: ConfigurationModuleOutputProtocol {
    
    func configurationDidChange(_ new: ConfigurationEntity) {
        searchTitle = new.title
        searchCategoryName = new.categoryName
        configSubject.onNext(new)
    }
}

private extension Observable where Element == String? {
    
    func filterByPrevious() -> Observable<String?> {
        return self
            .scan((nil, nil), accumulator: {
                ($0.1, $1) // (previous, current) pair
            })
            .filter { tuple in
                switch tuple {
                case (nil, nil):
                    return true // Initial call, do not skip
                case (nil, ""), ("", nil):
                    return false // Skip
                case _ where tuple.0 == tuple.1:
                    return false // Skip
                default:
                    return true // Others, do not skip
                }
            }
            .map { $0.1 } // Current value, if filter pass
    }
}
