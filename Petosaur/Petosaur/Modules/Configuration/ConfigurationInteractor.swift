//
//  ConfigurationInteractor.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

final class ConfigurationInteractor: ConfigurationInteractorProtocol {
    
    weak var presenter: ConfigurationPresenterProtocol?
    
    func createConfigResult(current: ConfigurationEntity,
                            newTitle: String?,
                            newCategoryName: String?) -> ConfigurationEntity? {
        if current.categoryName == newCategoryName, current.title == newTitle {
            return nil
        }
        
        return ConfigurationEntity(categoryName: newCategoryName, title: newTitle)
    }
}
