//
//  ModulesAssembly.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import Swinject

final class ModulesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(SearchModuleBuilderProtocol.self) { r in SearchModuleBuilder(resolver: r) }
    }
}
