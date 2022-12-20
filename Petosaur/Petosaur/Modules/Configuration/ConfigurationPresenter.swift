//
//  ConfigurationPresenter.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import UIKit

final class ConfigurationPresenter: ConfigurationPresenterProtocol {
    
    weak private var view: ConfigurationViewProtocol?
    var interactor: ConfigurationInteractorProtocol?
    private let router: ConfigurationRouterProtocol
    
    private let currentConfig: ConfigurationEntity
    weak private var output: ConfigurationModuleOutputProtocol?
    
    private var title: String?
    private var categoryName: String?
    
    init(view: ConfigurationViewProtocol,
         interactor: ConfigurationInteractorProtocol?,
         router: ConfigurationRouterProtocol,
         currentConfig: ConfigurationEntity,
         output: ConfigurationModuleOutputProtocol?) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
        
        self.currentConfig = currentConfig
        self.categoryName = currentConfig.categoryName
        self.title = currentConfig.title
    }
    
    func viewDidLoad() {
        view?.setTitleText(title: title)
        view?.setCategoryText(category: categoryName)
    }
    
    func titleDidUpdate(title: String?) {
        self.title = title
    }
    
    func categoryButtonDidTap() {
        router.chooseCategory(currentCategoryName: categoryName, output: self)
    }
    
    func saveButtonDidTap() {
        if let config = interactor?.createConfigResult(current: currentConfig, newTitle: title, newCategoryName: categoryName) {
            output?.configurationDidChange(config)
        }
        router.closeModule()
    }
    
    func resetButtonDidTap() {
        title = nil
        categoryName = nil
        saveButtonDidTap()
    }
}

extension ConfigurationPresenter: CategoriesModuleOutputProtocol {
    
    func categoryDidChange(categoryName: String?) {
        self.categoryName = categoryName
        view?.setCategoryText(category: categoryName)
    }
}
