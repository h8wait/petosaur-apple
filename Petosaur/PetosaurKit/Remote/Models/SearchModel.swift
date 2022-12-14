//
//  SearchModel.swift
//  PetosaurKit
//
//

import Foundation

/// This model contains search podcasts parameters
public struct SearchModel {
    
    public let search: String?
    public let title: String?
    public let categoryName: String?
    
    public let page: UInt
    public let limit: UInt
    
    public init(search: String?, title: String?, categoryName: String?, page: UInt, limit: UInt) {
        self.search = search
        self.title = title
        self.categoryName = categoryName
        self.page = page
        self.limit = limit
    }
}
