//
//  ModulesAssembly.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import Swinject

final class ModulesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(SearchModuleBuilderProtocol.self) { SearchModuleBuilder(resolver: $0) }
        container.register(ConfigurationModuleBuilderProtocol.self) { ConfigurationModuleBuilder(resolver: $0) }
    }
}
