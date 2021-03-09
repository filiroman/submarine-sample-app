//
//  MediaModels+Extensions.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.02.2021.
//

import Foundation
@testable import ItunesExample

extension AlbumMediaItemModel {
    static var testModel: AlbumMediaItemModel {
        return AlbumMediaItemModel(itemID: 1,
                                   description: "Test",
                                   artistName: "Test",
                                   albumName: "Test",
                                   previewUrl: nil,
                                   artworkUrl: nil,
                                   storeUrl: nil,
                                   releaseDate: nil)
    }
    
    static var testModelWithEmptyArtworkURL: AlbumMediaItemModel {
        return AlbumMediaItemModel(itemID: 0,
                                   description: nil,
                                   artistName: "TEST",
                                   albumName: "TEST",
                                   previewUrl: nil,
                                   artworkUrl: nil,
                                   storeUrl: nil,
                                   releaseDate: nil)
    }
    
    static var testModelWithArtworkURL: AlbumMediaItemModel {
        return AlbumMediaItemModel(itemID: 0,
                                   description: nil,
                                   artistName: "TEST",
                                   albumName: "TEST",
                                   previewUrl: nil,
                                   artworkUrl: URL(string: "https://example.com/"),
                                   storeUrl: nil,
                                   releaseDate: nil)
    }
}

extension TrackMediaItemModel {
    static var testModel: TrackMediaItemModel {
        return TrackMediaItemModel(itemID: 1,
                                   description: "Test",
                                   artistName: "Test",
                                   trackName: "Test",
                                   albumName: "Test",
                                   artworkUrl: nil,
                                   storeUrl: nil,
                                   releaseDate: nil,
                                   wrapperType: nil)
    }
}
