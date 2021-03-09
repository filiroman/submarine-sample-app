//
//  AlbumViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import RxSwift
@testable import ItunesExample

class AlbumViewModelMock: AlbumViewModel {
    // MARK: - AlbumViewModel
    var albumTitle: String {
        return mockAlbumTitle
    }
    var artistTitle: String {
        return mockArtistTitle
    }
    var albumId: AlbumID = 0
    var coverImageUrl: URL? {
        return mockCoverImageUrl
    }
    
    var searchActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Mock Properties
    var mockAlbumTitle: String = ""
    var mockArtistTitle: String = ""
    var mockCoverImageUrl: URL?
    
    var getPreviewImageCalled = false
    var mockPreviewImage: UIImage?
    
    var cancelCoverLoadingCalled = false
    
    func getPreviewImage(completion: @escaping (UIImage?) -> Void) {
        getPreviewImageCalled = true
        completion(mockPreviewImage)
    }
    
    func cancelCoverLoading() {
        cancelCoverLoadingCalled = true
    }
    
    
}
