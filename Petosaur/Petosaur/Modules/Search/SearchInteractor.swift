//
//  SearchInteractor.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import PetosaurKit

final class SearchInteractor: SearchInteractorProtocol {
    
    private let provider: SearchProviderProtocol
    
    weak var presenter: SearchPresenterProtocol?
    
    init(provider: SearchProviderProtocol) {
        self.provider = provider
    }
    
    func startSearch(text: String?, title: String?, categoryName: String?, page: UInt, limit: UInt) {
        
        presenter?.searchDidStart()
        
        let model = createModel(search: text, title: title, categoryName: categoryName, page: page, limit: limit)
        provider.getByQuery(model) { [weak self] result in
            switch result {
            case .success(let models):
                if models.isEmpty {
                    // No results
                    self?.presenter?.searchDidEmpty()
                } else {
                    // Results
                    let entities = models.map { $0.asEntity() }
                    self?.presenter?.searchDidResults(items: entities)
                }
                self?.completeSearchIfNeeded(lastPage: models, pageLimit: limit)
            case .failure:
                self?.presenter?.searchDidFailed()
                self?.presenter?.searchDidComplete()
            }
        }
    }
    
    func startFetch(text: String?, title: String?, categoryName: String?, lastLoadedPage: UInt, limit: UInt) {
        let model = createModel(search: text, title: title, categoryName: categoryName, page: lastLoadedPage + 1, limit: limit)
        provider.getByQuery(model) { [weak self] result in
            switch result {
            case .success(let models):
                if models.isEmpty == false {
                    // Next results
                    let entities = models.map { $0.asEntity() }
                    self?.presenter?.fetchDidResults(items: entities)
                }
                self?.completeSearchIfNeeded(lastPage: models, pageLimit: limit)
            case .failure:
                self?.presenter?.fetchDidFailed()
            }
        }
    }
    
    private func createModel(search: String?, title: String?, categoryName: String?, page: UInt, limit: UInt) -> SearchModel {
        
        func fix(text: String?) -> String? {
            if let value = text, value.isEmpty {
                return nil
            }
            return text
        }
        
        return SearchModel(search: fix(text: search),
                           title: fix(text: title),
                           categoryName: fix(text: categoryName),
                           page: page,
                           limit: limit)
    }
    
    private func completeSearchIfNeeded(lastPage: [PodcastModel], pageLimit: UInt) {
        if lastPage.count < pageLimit {
            presenter?.searchDidComplete()
        }
    }
}

private extension PodcastModel {
    
    func asEntity() -> PodcastEntity {
        PodcastEntity(
            title: title,
            publisher: publisherName,
            imageURL: imageURL)
    }
}
