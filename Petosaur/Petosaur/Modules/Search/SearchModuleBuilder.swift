//
//  SearchModuleBuilder.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import PetosaurKit

final class SearchModuleBuilder {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
}

extension SearchModuleBuilder: SearchModuleBuilderProtocol {
    
    func createSearchModule() -> UIViewController {
        
        guard let provider = resolver.resolve(SearchProviderProtocol.self) else {
            return UIViewController()
        }
        
        let view = SearchViewController()
        let interactor = SearchInteractor(provider: provider)
        let router = SearchRouter(configurationBuilder: resolver.resolve(ConfigurationModuleBuilderProtocol.self))
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return UINavigationController(rootViewController: view)
    }
}
