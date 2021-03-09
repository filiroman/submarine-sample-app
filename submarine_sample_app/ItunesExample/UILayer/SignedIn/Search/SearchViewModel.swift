//
//  SearchViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation
import RxSwift

protocol SearchViewModel: class {
    var errorMessages: Observable<ErrorMessage> { get }
    var searchInput: BehaviorSubject<String> { get }
    var searchActivityIndicatorAnimating: BehaviorSubject<Bool> { get }
    var albums: BehaviorSubject<[AlbumViewModel]> { get }
    var errorPresentation: BehaviorSubject<ErrorPresentation?> { get }
    
    func modelSelected(model: AlbumViewModel)
    func search(query: String)
}

class SearchViewModelImpl: SearchViewModel {
    
    // MARK: - Properties
    let mediaAPI: MediaLibraryRemoteAPI
    let responder: AlbumModelSelectedResponder
    
    let disposeBag = DisposeBag()
    
    public let searchInput = BehaviorSubject<String>(value: "")
    public let searchActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    public let albums = BehaviorSubject<[AlbumViewModel]>(value: [])
    
    public var errorMessages: Observable<ErrorMessage> {
        return self.errorMessagesSubject.asObserver()
    }
    public let errorMessagesSubject: PublishSubject<ErrorMessage> = PublishSubject()
    public let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    
    var searchTask: URLSessionDataTask?
    // Factory
    let makeAlbumViewModel: (AlbumMediaItemModel) -> AlbumViewModel
    
    // MARK: - Methods
    public init(mediaAPI: MediaLibraryRemoteAPI,
                responder: AlbumModelSelectedResponder,
                makeAlbumViewModel: @escaping (AlbumMediaItemModel) -> AlbumViewModel) {
        self.mediaAPI = mediaAPI
        self.responder = responder
        self.makeAlbumViewModel = makeAlbumViewModel
        bindToSearchInput()
    }
    
    func bindToSearchInput() {
        searchInput.subscribe(onNext: { [weak self](query) in
            guard let strong = self else { return }
            strong.search(query: query)
        }).disposed(by: disposeBag)
    }
    
    func refresh() {
        guard let query = try? searchInput.value() else { return }
        search(query: query)
    }
    
    func modelSelected(model: AlbumViewModel) {
        responder.modelSelected(model: model)
    }
    
    func search(query: String) {
        guard !query.isEmpty else {
            return
        }
        
        searchTask?.cancel()
        
        indicateSearchInProgress()
        searchTask = mediaAPI.fetchAlbums(withQuery: query) { [weak self](albums, error) in
            guard let strong = self else { return }
            strong.indicateSearchFinished()
            if let error = error {
                strong.indicateFetchError(error)
            } else if let albums = albums {
                let viewModels = albums.compactMap({ strong.makeAlbumViewModel($0) })
                strong.albums.onNext(viewModels)
            }
        } 
    }
    
    private func indicateSearchInProgress() {
        searchActivityIndicatorAnimating.onNext(true)
    }
    
    private func indicateSearchFinished() {
        searchActivityIndicatorAnimating.onNext(false)
    }
    
    // MARK: - Error handling
    func present(errorMessage: ErrorMessage) {
        errorMessagesSubject.onNext(errorMessage)
    }

    func indicateFetchError(_ error: Error) {
        let errorMessage = ErrorMessage(title: "Error!".localized,
                                        message: error.localizedDescription)
        self.present(errorMessage: errorMessage)
    }
}
