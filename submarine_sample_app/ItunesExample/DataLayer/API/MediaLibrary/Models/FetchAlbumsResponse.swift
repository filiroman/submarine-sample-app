//
//  FetchAlbumsResponse.swift
//  ItunesExample
//
//  Created by Roman Filippov on 02.02.2021.
//

import Foundation

struct FetchAlbumsResponse: Decodable {
    let resultCount: Int
    let results: [AlbumMediaItemModel]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}
