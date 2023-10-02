//
//  SongModel.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import Foundation

struct Song: Decodable {
    let artwork: String
    let bookName: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case artwork = "artworkUrl100"
        case bookName = "trackName"
    }
}
