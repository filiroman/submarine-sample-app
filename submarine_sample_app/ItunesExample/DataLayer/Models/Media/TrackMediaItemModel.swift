//
//  TrackMediaItemModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation

struct TrackMediaItemModel: Decodable, Equatable {
    let itemID: Int?
    let description: String?
    let artistName: String
    let trackName: String?
    let albumName: String
    let artworkUrl: URL?
    let storeUrl: URL?
    let releaseDate: String?
    let wrapperType: String?
    
    private enum CodingKeys: String, CodingKey {
        case itemID = "trackId"
        case description
        case artistName = "artistName"
        case trackName = "trackName"
        case albumName = "collectionName"
        case artworkUrl = "artworkUrl100"
        case storeUrl = "storeUrl"
        case releaseDate = "releaseDate"
        case wrapperType = "wrapperType"
    }
    
    public static func == (lhs: TrackMediaItemModel, rhs: TrackMediaItemModel) -> Bool {
        return lhs.itemID == rhs.itemID
    }
}

extension Collection where Element == TrackMediaItemModel {
    func removingAlbumMetaInfo() -> [Element] {
        return self.filter({$0.wrapperType == "track"})
    }
}
