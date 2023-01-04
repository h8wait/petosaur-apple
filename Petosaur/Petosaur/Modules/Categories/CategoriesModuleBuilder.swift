//
//  CategoriesModuleBuilder.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import SwiftUI
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
        
        let viewAdapter = CategoriesViewAdapter()
        let view = CategoriesView(adapter: viewAdapter)
        let host = UIHostingController(rootView: view)
        let interactor = CategoriesInteractor(categoriesProvider: provider)
        let router = CategoriesRouter()
        let presenter = CategoriesPresenter(view: viewAdapter, interactor: interactor, router: router, output: output)
        
        viewAdapter.presenter = presenter
        interactor.presenter = presenter
        router.viewController = host
        
        return host
    }
}
