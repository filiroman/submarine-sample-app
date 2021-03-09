//
//  MediaLibraryRemoteAPI.swift
//  ItunesExample
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

typealias AlbumID = Int

protocol MediaLibraryRemoteAPI: class {
    @discardableResult
    func fetchAlbums(withQuery query: String, completion: @escaping([AlbumMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask?
    @discardableResult
    func fetchTracks(withAlbumId albumId: AlbumID, completion: @escaping([TrackMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask?
}
