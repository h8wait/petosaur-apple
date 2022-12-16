//
//  ServicesAssembly.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import Swinject

final class ServicesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        let sceneService = SceneService(resolver: container)
        container.register(SceneServiceProtocol.self) { _ in sceneService }
    }
}
