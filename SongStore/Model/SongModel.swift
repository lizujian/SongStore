//
//  SongModel.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}

struct Song: Decodable {
    let wrapperType: String?
    let kind: String
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int
    let artistName: String
    let collectionName: String?
    let trackName: String
    let collectionCensoredName: String?
    let trackCensoredName: String
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Float?
    let trackPrice: Float?
    let releaseDate: String
    let collectionExplicitness: String
    let trackExplicitness: String
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String
    let currency: String
    let primaryGenreName: String
    let isStreamable: Bool?
}
