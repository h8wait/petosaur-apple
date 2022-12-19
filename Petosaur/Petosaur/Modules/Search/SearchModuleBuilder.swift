//
//  SearchModuleBuilder.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import PetosaurKit

final class SearchModuleBuilder {
    
    private let provider: SearchProviderProtocol
    private let configurationFactory: ConfigurationModuleFactoryProtocol?
    
    private init(provider: SearchProviderProtocol, configurationFactory: ConfigurationModuleFactoryProtocol?) {
        self.provider = provider
        self.configurationFactory = configurationFactory
    }
    
    convenience init(resolver: Resolver) {
        self.init(
            provider: resolver.resolve(SearchProviderProtocol.self)!,
            configurationFactory: resolver.resolve(ConfigurationModuleFactoryProtocol.self)
        )
    }
}

extension SearchModuleBuilder: SearchModuleBuilderProtocol {
    
    func createSearchModule() -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor(provider: provider)
        let router = SearchRouter(configurationFactory: configurationFactory)
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
