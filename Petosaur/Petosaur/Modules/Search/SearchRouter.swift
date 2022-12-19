//
//  SearchRouter.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit

final class SearchRouter: SearchRouterProtocol {
    
    weak var configurationFactory: ConfigurationModuleFactoryProtocol?
    weak var viewController: UIViewController?
    
    init(configurationFactory: ConfigurationModuleFactoryProtocol?) {
        self.configurationFactory = configurationFactory
    }
    
    func configureSearch(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol) {
        guard let module = configurationFactory?.createConfigurationModule(currentConfig: currentConfig,
                                                                           output: output) else {
            return
        }
        
        viewController?.navigationController?.pushViewController(module, animated: true)
    }
}
