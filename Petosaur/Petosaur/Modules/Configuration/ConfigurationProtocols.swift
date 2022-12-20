//
//  ConfigurationProtocols.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import Foundation
import UIKit

protocol ConfigurationModuleOutputProtocol: AnyObject {
    
    func configurationDidChange(_ new: ConfigurationEntity)
}

protocol ConfigurationModuleBuilderProtocol: AnyObject {
    
    func createConfigurationModule(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol?) -> UIViewController
}

//MARK: View -
protocol ConfigurationViewProtocol: AnyObject {
    
    var presenter: ConfigurationPresenterProtocol?  { get set }
    
    func setTitleText(title: String?)
    func setCategoryText(category: String?)
}

//MARK: Interactor -
protocol ConfigurationInteractorProtocol: AnyObject {
    
    var presenter: ConfigurationPresenterProtocol?  { get set }
    
    func createConfigResult(current: ConfigurationEntity,
                            newTitle: String?,
                            newCategoryName: String?) -> ConfigurationEntity?
}

//MARK: Presenter -
protocol ConfigurationPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    
    func titleDidUpdate(title: String?)
    func categoryButtonDidTap()
    func saveButtonDidTap()
    func resetButtonDidTap()
}

//MARK: Router -
protocol ConfigurationRouterProtocol: AnyObject {
    
    func chooseCategory(currentCategoryName: String?, output: CategoriesModuleOutputProtocol?)
    func closeModule()
}
