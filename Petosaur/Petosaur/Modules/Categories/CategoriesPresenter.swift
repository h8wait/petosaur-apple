//
//  CategoriesPresenter.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import UIKit

final class CategoriesPresenter: CategoriesPresenterProtocol {
    
    private weak var output: CategoriesModuleOutputProtocol?
    
    weak private var view: CategoriesViewProtocol?
    var interactor: CategoriesInteractorProtocol?
    private let router: CategoriesRouterProtocol
    
    init(view: CategoriesViewProtocol,
         interactor: CategoriesInteractorProtocol?,
         router: CategoriesRouterProtocol,
         output: CategoriesModuleOutputProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
    }
    
    func viewDidLoad() {
        interactor?.fetchCategories()
    }
    
    func categoriesDidLoad(items: [String]) {
        view?.showCategories(items: items)
    }
    
    func categoriesDidFail() {
        // Service is stubed, no implementation for now
    }
    
    func categoryDidTap(name: String) {
        output?.categoryDidChange(categoryName: name)
        router.closeModule()
    }
}
