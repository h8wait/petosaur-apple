//
//  SearchRouter.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit

final class SearchRouter: SearchRouterProtocol {
    
    private let configurationBuilder: ConfigurationModuleBuilderProtocol?
    weak var viewController: UIViewController?
    
    init(configurationBuilder: ConfigurationModuleBuilderProtocol?) {
        self.configurationBuilder = configurationBuilder
    }
    
    func configureSearch(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol) {
        guard let module = configurationBuilder?.createConfigurationModule(currentConfig: currentConfig,
                                                                           output: output) else {
            return
        }
        
        viewController?.navigationController?.pushViewController(module, animated: true)
    }
}
