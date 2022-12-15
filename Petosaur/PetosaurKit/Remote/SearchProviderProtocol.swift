//
//  SearchProviderProtocol.swift
//  PetosaurKit
//
//

public typealias SearchProviderResult = Result<[PodcastModel], ErrorModel>

/// Component to work with podcasts data
public protocol SearchProviderProtocol: AnyObject {
    
    /// Search podcasts method
    /// - Parameters:
    ///   - query: Model of the search
    ///   - completion: Result of the search: list of podcast models or a error model
    func getByQuery(_ query: SearchModel, completion: @escaping (SearchProviderResult) -> Void)
}
