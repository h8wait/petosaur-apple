//
//  CategoriesProviderProtocol.swift
//  PetosaurKit
//
//

public typealias CategoriesProviderResult = Result<[CategoryModel], Error>

/// Component to work with podcasts categories
public protocol CategoriesProviderProtocol: AnyObject {
    
    /// Returns all available categories
    /// - Parameter completion: Result categories list or a error
    func getAll(completion: @escaping (CategoriesProviderResult) -> Void)
}
