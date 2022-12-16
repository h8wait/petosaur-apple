//
//  PetosaurDIContainer.swift
//  Petosaur
//
//  Created by h8wait on 16.12.2022.
//

import Swinject

// Alias for Swinject protocol, to get rid of imports
typealias Resolver = Swinject.Resolver

final class PetosaurDIContainer {
    
    private let assembler: Assembler
    
    public var resolver: Resolver {
        assembler.resolver
    }
    
    init() {
        assembler = Assembler()
    }
    
    func configure() {
        assembler.apply(assemblies: [
            ServicesAssembly(),
            ModulesAssembly()
        ])
    }
}
