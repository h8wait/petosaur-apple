//
//  SceneService.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import UIKit

protocol SceneServiceProtocol {
    
    func connectRootModuleTo(_ scene: UIWindowScene, in window: UIWindow)
}

final class SceneService {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
}

extension SceneService: SceneServiceProtocol {
    
    func connectRootModuleTo(_ scene: UIWindowScene, in window: UIWindow) {
        window.windowScene = scene
        window.rootViewController = UIViewController()
        window.rootViewController?.view.backgroundColor = .red
    }
}
