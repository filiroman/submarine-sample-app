//
//  FetchTracksResponse.swift
//  ItunesExample
//
//  Created by Roman Filippov on 26.02.2021.
//

import Foundation

struct FetchTracksResponse: Decodable {
    let resultCount: Int
    let results: [TrackMediaItemModel]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}
