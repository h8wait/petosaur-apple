//
//  SearchResultDataProvider.swift
//  PetosaurKit
//
//

import Foundation
import Alamofire

public final class SearchResultDataProvider {
    
    private let endpointURL: URL?
    
    public init(endpointURL: URL?) {
        self.endpointURL = endpointURL?.appendingPathComponent("podcasts")
    }
}

extension SearchResultDataProvider: SearchProviderProtocol {
    
    public func getByQuery(_ query: SearchModel, completion: @escaping (SearchProviderResult) -> Void) {
        let components = query.asURLComponents()
        guard let url = components.url(relativeTo: endpointURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url)
            .cURLDescription { description in
                print(description)
            }
            .validate()
            .responseDecodable { (responce: DataResponse<[Podcast], AFError>) in
                let result = responce.result
                    .mapError { _ -> ErrorModel in
                        // All errors are considered as API errors
                        .remote
                    }
                    .map {
                        // Mapping to model
                        $0.map { $0.asModel() }
                    }
                completion(result)
            }
    }
}

private extension SearchModel {
    
    func asURLComponents() -> URLComponents {
        
        var queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        // Adding some properties to components if they exist
        
        if let search = search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        
        if let title = title {
            queryItems.append(URLQueryItem(name: "title", value: title))
        }
        
        if let categoryName = categoryName {
            queryItems.append(URLQueryItem(name: "categoryName", value: categoryName))
        }
        
        var components = URLComponents()
        components.queryItems = queryItems
        return components
    }
}

private extension Podcast {
    
    func asModel() -> PodcastModel {
        PodcastModel(
            id: id,
            title: title,
            imageURL: images.thumbnail,
            publisherName: publisherName,
            description: description,
            categoryId: categoryId,
            categoryName: categoryName)
    }
}
