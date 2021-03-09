//
//  ITunesMediaLibraryRemoteAPI.swift
//  ItunesExample
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

class ITunesMediaLibraryRemoteAPI: MediaLibraryRemoteAPI {
    // MARK: - Properties
    let networkService: NetworkService
    
    // MARK: - Methods
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @discardableResult
    func fetchAlbums(withQuery query: String, completion: @escaping ([AlbumMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask? {
        guard !query.isEmpty else {
            completion([], nil)
            return nil
        }
        guard let url = URL(string: ITunes.Constants.baseSearchURL) else {
            completion(nil, AppError.unknown)
            return nil
        }
        let parameters = [ITunes.Fields.media.rawValue: ITunes.Media.music.rawValue,
                          ITunes.Fields.entity.rawValue: ITunes.Entity.album.rawValue,
                          ITunes.Fields.term.rawValue: query]
        let task = networkService.loadRequest(url: url, parameters: parameters) { (result: NetworkResult<FetchAlbumsResponse>) in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let data):
                let results = data.results
                completion(results, nil)
            }
        }
        return task
    }
    
    @discardableResult
    func fetchTracks(withAlbumId albumId: AlbumID, completion: @escaping([TrackMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: ITunes.Constants.baseLookupURL) else {
            completion(nil, AppError.unknown)
            return nil
        }
        let parameters = [ITunes.Fields.media.rawValue: ITunes.Media.music.rawValue,
                          ITunes.Fields.entity.rawValue: ITunes.Entity.song.rawValue,
                          ITunes.Fields.id.rawValue: String(albumId)]
        let task = networkService.loadRequest(url: url, parameters: parameters) { (result: NetworkResult<FetchTracksResponse>) in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let data):
                let results = data.results.removingAlbumMetaInfo()
                completion(results, nil)
            }
        }
        return task
    }
    
}
