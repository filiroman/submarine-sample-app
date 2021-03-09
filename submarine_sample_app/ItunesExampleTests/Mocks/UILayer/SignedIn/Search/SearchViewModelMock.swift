//
//  SearchViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation
import RxSwift
@testable import ItunesExample

class SearchViewModelMock: SearchViewModel {
    
    var errorMessages: Observable<ErrorMessage> {
        return self.errorMessagesSubject.asObserver()
    }
    let searchInput = BehaviorSubject<String>(value: "")
    let searchActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    let albums = BehaviorSubject<[AlbumViewModel]>(value: [])
    let selectedAlbum = BehaviorSubject<AlbumViewModel?>(value: nil)
    
    let errorMessagesSubject: PublishSubject<ErrorMessage> = PublishSubject()
    let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Mock Properties
    var searchCalled = false
    var refreshCalled = false
    var modelSelectedCalled = false
    var searchCalledWithString: String?
    
    init() {
        searchActivityIndicatorAnimating.subscribe(onNext: { (animating) in
            NotificationCenter.default.post(name: Notification.activityIndicatorAnimatingSequenceNotification, object: nil)
        }).disposed(by: disposeBag)
        
        albums.subscribe(onNext: { (next) in
            NotificationCenter.default.post(name: Notification.albumsSequenceNotification, object: nil)
        }).disposed(by: disposeBag)
    }
    
    func modelSelected(model: AlbumViewModel) {
        modelSelectedCalled = true
    }
    
    func search(query: String) {
        searchCalled = true
        searchCalledWithString = query
        NotificationCenter.default.post(name: Notification.searchIsCalledNotification, object: nil)
    }
}
