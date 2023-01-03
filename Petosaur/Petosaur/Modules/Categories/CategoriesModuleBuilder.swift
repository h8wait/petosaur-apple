//
//  CategoriesModuleBuilder.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import UIKit
import PetosaurKit

final class CategoriesModuleBuilder {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
}

extension CategoriesModuleBuilder: CategoriesModuleBuilderProtocol {
    
    func createCategoriesModule(currentCategoryName: String?, output: CategoriesModuleOutputProtocol?) -> UIViewController {
        
        guard let provider = resolver.resolve(CategoriesProviderProtocol.self) else {
            return UIViewController()
        }
        
        let view = CategoriesViewController()
        let interactor = CategoriesInteractor(categoriesProvider: provider)
        let router = CategoriesRouter()
        let presenter = CategoriesPresenter(view: view, interactor: interactor, router: router, output: output)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
