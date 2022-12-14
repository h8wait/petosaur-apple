//
//  CategoriesDataProvider.swift
//  PetosaurKit
//
//

public final class CategoriesDataProvider {
    
    public init() { }
}

extension CategoriesDataProvider: CategoriesProviderProtocol {
    
    public func getAll(completion: @escaping (CategoriesProviderResult) -> Void) {
        
        // TODO: Stubbed implementation, need to implement API call
        let items = [
            CategoryModel(id: "bd178e02-1ae8-43e1-a2c8-c66ef8c1e7dd", name: "History"),
            CategoryModel(id: "074d8bbe-3477-4ead-8078-2cc17cc6c37c", name: "Comedy"),
            CategoryModel(id: "422aee5c-5398-441a-845e-c96c40627c8f", name: "Society & Culture")
        ]
        
        completion(.success(items))
    }
}
