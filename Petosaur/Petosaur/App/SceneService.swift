//
//  SceneService.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import UIKit

protocol SceneServiceProtocol {
    
    func connectRootModuleTo(_ scene: UIWindowScene, delegate: SceneDelegate)
}

final class SceneService {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
}

extension SceneService: SceneServiceProtocol {
    
    func connectRootModuleTo(_ scene: UIWindowScene, delegate: SceneDelegate) {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        delegate.window = window
        
        let rootModuleBuilder = resolver.resolve(SearchModuleBuilderProtocol.self)
        window.rootViewController = rootModuleBuilder?.createSearchModule()
        window.windowScene = scene
        window.makeKeyAndVisible()
    }
}
