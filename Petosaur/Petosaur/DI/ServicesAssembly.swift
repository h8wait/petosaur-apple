//
//  ServicesAssembly.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import Swinject
import PetosaurKit

final class ServicesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        let sceneService = SceneService(resolver: container)
        container.register(SceneServiceProtocol.self) { _ in sceneService }
        
        let searchProvider = SearchResultDataProvider(
            endpointURL: URL(string: "https://601f1754b5a0e9001706a292.mockapi.io")
        )
        container.register(SearchProviderProtocol.self) { _ in searchProvider }
        
        let categoriesProvider =  CategoriesDataProvider()
        container.register(CategoriesProviderProtocol.self) { _ in categoriesProvider }
    }
}
