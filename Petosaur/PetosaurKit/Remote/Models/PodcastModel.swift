//
//  PodcastModel.swift
//  PetosaurKit
//
//

import Foundation

/// This struct is simplistic podcast data transfer object
public struct PodcastModel {
    
    public let id: String
    public let title: String
    public let imageURL: URL?
    public let publisherName: String
    public let description: String
    public let categoryId: String
    public let categoryName: String
}
