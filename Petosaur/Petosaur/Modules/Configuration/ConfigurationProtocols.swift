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

protocol ConfigurationModuleFactoryProtocol: AnyObject {
    
    func createConfigurationModule(currentConfig: ConfigurationEntity, output: ConfigurationModuleOutputProtocol?) -> UIViewController
}
