//
//  AlbumDetailsViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import RxSwift
@testable import ItunesExample

class AlbumDetailsViewModelMock: AlbumDetailsViewModel {
    // MARK: - AlbumDetailsViewModel
    let loadingActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    let imageLoadingActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    var tracks = BehaviorSubject<[TrackViewModel]>(value: [])
    
    var albumTitle: String {
        return mockAlbumTitle
    }
    
    var artistTitle: String {
        return mockArtistTitle
    }
    
    var errorMessages: Observable<ErrorMessage> {
        return self.errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject: PublishSubject<ErrorMessage> = PublishSubject()
    let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    
    // MARK: - Mock Properties
    var mockAlbumTitle: String = ""
    var mockArtistTitle: String = ""
    var fetchDataIsCalled = false
    
    func fetchData() {
        fetchDataIsCalled = true
    }
    
    func getCoverImage(completion: @escaping (UIImage?) -> Void) {
        
    }
    
    func cancelCoverLoading() {
        
    }
}
