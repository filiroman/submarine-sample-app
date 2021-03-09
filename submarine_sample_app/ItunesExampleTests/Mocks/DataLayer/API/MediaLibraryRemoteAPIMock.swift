//
//  MediaLibraryRemoteAPIMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation
@testable import ItunesExample

class MediaLibraryRemoteAPIMock: MediaLibraryRemoteAPI {
    var albumsCompletionHandler: (([AlbumMediaItemModel]?, Error?) -> Void)?
    var tracksCompletionHandler: (([TrackMediaItemModel]?, Error?) -> Void)?
    var lastSessionTask: MockURLSessionDataTask?
    
    var fetchAlbumsCalled = false
    var fetchTracksCalled = false
    
    var exampleURL: URL {
        return URL(string: "https://example.com")!
    }
    
    func fetchAlbums(withQuery query: String, completion: @escaping ([AlbumMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask? {
        fetchAlbumsCalled = true
        NotificationCenter.default.post(name: Notification.fetchAlbumsCalledNotification, object: nil)
        albumsCompletionHandler = completion
        lastSessionTask = MockURLSessionDataTask(completionHandler: { (_, _, _) in }, url: exampleURL, queue: nil)
        return lastSessionTask
    }
    
    func fetchTracks(withAlbumId albumId: AlbumID, completion: @escaping([TrackMediaItemModel]?, Error?) -> Void) -> URLSessionDataTask? {
        fetchTracksCalled = true
        NotificationCenter.default.post(name: Notification.fetchTracksCalledNotification, object: nil)
        tracksCompletionHandler = completion
        lastSessionTask = MockURLSessionDataTask(completionHandler: { (_, _, _) in }, url: exampleURL, queue: nil)
        return lastSessionTask
    }
}
