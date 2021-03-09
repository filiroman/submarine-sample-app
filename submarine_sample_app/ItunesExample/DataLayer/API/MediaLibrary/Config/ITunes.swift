//
//  ITunesMediaLibraryConstants.swift
//  ItunesExample
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation

struct ITunes {
    struct Constants {
        static let baseURL = "https://itunes.apple.com/"
        static let baseSearchURL = ITunes.Constants.baseURL + "search"
        static let baseLookupURL = ITunes.Constants.baseURL + "lookup"
    }
    
    enum Fields: String {
        case media
        case entity
        case term
        case id
    }
    
    // Media field from :
    // https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
    //
    enum Media: String {
        case movie
        case podcast
        case music
        case musicVideo
        case audiobook
        case shortFilm
        case tvShow
        case software
        case ebook
        case all
        
    }
    
    // Entity fields from :
    // https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
    //
    enum Entity: String {
        // Media.music
        case musicArtist
        case musicTrack
        case album
        case musicVideo
        case mix
        case song
    }
}
