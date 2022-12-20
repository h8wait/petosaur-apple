//
//  ConfigurationModuleBuilder.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import UIKit

final class ConfigurationModuleBuilder {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
}

extension ConfigurationModuleBuilder: ConfigurationModuleBuilderProtocol {
    
    func createConfigurationModule(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol?) -> UIViewController {
        let view = ConfigurationViewController()
        let interactor = ConfigurationInteractor()
        let router = ConfigurationRouter(categoriesBuilder: resolver.resolve(CategoriesModuleBuilderProtocol.self))
        let presenter = ConfigurationPresenter(
            view: view,
            interactor: interactor,
            router: router,
            currentConfig: currentConfig,
            output: output
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
