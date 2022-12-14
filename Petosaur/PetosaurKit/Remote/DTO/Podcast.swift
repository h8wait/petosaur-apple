//
//  Podcast.swift
//  PetosaurKit
//
//

import Foundation

struct Images: Codable {
    let `default`: URL?
    let featured: URL?
    let thumbnail: URL?
    let wide: URL?
}

struct Podcast: Codable {
    let id: String
    let title: String
    let images: Images
    let isExclusive: Bool
    let publisherName: String
    let publisherId: String
    let mediaType: String
    let description: String
    let categoryId: String
    let categoryName: String
    let hasFreeEpisodes: Bool
    let playSequence: String
}
