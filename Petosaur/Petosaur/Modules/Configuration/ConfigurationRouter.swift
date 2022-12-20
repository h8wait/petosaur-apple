//
//  ConfigurationRouter.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import UIKit

final class ConfigurationRouter: ConfigurationRouterProtocol {
    
    private let categoriesBuilder: CategoriesModuleBuilderProtocol?
    weak var viewController: UIViewController?
    
    init(categoriesBuilder: CategoriesModuleBuilderProtocol?) {
        self.categoriesBuilder = categoriesBuilder
    }
    
    func chooseCategory(currentCategoryName: String?, output: CategoriesModuleOutputProtocol?) {
        guard let module = categoriesBuilder?.createCategoriesModule(currentCategoryName: currentCategoryName,
                                                                     output: output) else {
            return
        }
        
        module.isModalInPresentation = true
        viewController?.navigationController?.present(module, animated: true, completion: nil)
    }
    
    func closeModule() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
