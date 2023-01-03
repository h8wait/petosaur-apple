//
//  CategoriesProtocols.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import Foundation
import UIKit

protocol CategoriesModuleBuilderProtocol: AnyObject {
    
    func createCategoriesModule(currentCategoryName: String?,
                                output: CategoriesModuleOutputProtocol?) -> UIViewController
}

protocol CategoriesModuleOutputProtocol: AnyObject {
    
    func categoryDidChange(categoryName: String?)
}

// MARK: - View
protocol CategoriesViewProtocol: AnyObject {
    
    var presenter: CategoriesPresenterProtocol? { get set }
    
    func showCategories(items: [String])
}

// MARK: - Interactor
protocol CategoriesInteractorProtocol: AnyObject {
    
    var presenter: CategoriesPresenterProtocol? { get set }
    
    func fetchCategories()
}

// MARK: - Presenter
protocol CategoriesPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func categoriesDidLoad(items: [String])
    func categoriesDidFail()
    
    func categoryDidTap(name: String)
}

// MARK: - Router
protocol CategoriesRouterProtocol: AnyObject {
    
    func closeModule()
}
