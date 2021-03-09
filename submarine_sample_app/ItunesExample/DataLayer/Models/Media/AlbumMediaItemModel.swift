//
//  AlbumMediaItemModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation

struct AlbumMediaItemModel: Decodable, Equatable {
    let itemID: Int
    let description: String?
    let artistName: String
    let albumName: String
    let previewUrl: URL?
    let artworkUrl: URL?
    let storeUrl: URL?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case itemID = "collectionId"
        case description
        case artistName = "artistName"
        case albumName = "collectionName"
        case previewUrl = "artworkUrl60"
        case artworkUrl = "artworkUrl100"
        case storeUrl = "storeUrl"
        case releaseDate = "releaseDate"
    }
    
    public static func == (lhs: AlbumMediaItemModel, rhs: AlbumMediaItemModel) -> Bool {
        return lhs.itemID == rhs.itemID
    }
}
