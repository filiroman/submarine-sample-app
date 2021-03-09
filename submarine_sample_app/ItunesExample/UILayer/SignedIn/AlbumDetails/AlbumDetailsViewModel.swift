//
//  AlbumDetailsViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import UIKit
import RxSwift

protocol AlbumDetailsViewModel: class {
    var errorMessages: Observable<ErrorMessage> { get }
    var loadingActivityIndicatorAnimating: BehaviorSubject<Bool> { get }
    var imageLoadingActivityIndicatorAnimating: BehaviorSubject<Bool> { get }
    
    var tracks: BehaviorSubject<[TrackViewModel]> { get }
    var errorPresentation: BehaviorSubject<ErrorPresentation?> { get }
    
    var albumTitle: String { get }
    var artistTitle: String { get }
    
    func fetchData()
    func getCoverImage(completion: @escaping (UIImage?) -> Void)
    func cancelCoverLoading()
}

class AlbumDetailsViewModelImpl: AlbumDetailsViewModel {
    
    // MARK: - Properties
    let loadingActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    let imageLoadingActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    let tracks = BehaviorSubject<[TrackViewModel]>(value: [])
    
    var errorMessages: Observable<ErrorMessage> {
        return self.errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject: PublishSubject<ErrorMessage> = PublishSubject()
    let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    
    var albumTitle: String {
        return model.albumTitle
    }
    
    var artistTitle: String {
        return model.artistTitle
    }
    
    private let model: AlbumViewModel
    private let mediaAPI: MediaLibraryRemoteAPI
    private let imageService: ImageService
    
    private var fetchDataTask: URLSessionDataTask?
    private var fetchCoverTask: URLSessionDataTask?
    
    // MARK: - Methods
    init(model: AlbumViewModel, mediaAPI: MediaLibraryRemoteAPI, imageService: ImageService) {
        self.model = model
        self.mediaAPI = mediaAPI
        self.imageService = imageService
    }
    
    func fetchData() {
        loadingActivityIndicatorAnimating.onNext(true)
        fetchDataTask?.cancel()
        fetchDataTask = mediaAPI.fetchTracks(withAlbumId: model.albumId) { [weak self](tracks, error) in
            self?.loadingActivityIndicatorAnimating.onNext(false)
            if let error = error {
                self?.errorMessagesSubject.onNext(ErrorMessage(error: error))
            } else if let tracks = tracks {
                let viewModels: [TrackViewModel] = tracks.compactMap({ TrackViewModelImpl(model: $0 )})
                self?.tracks.onNext(viewModels)
            }
        }
    }
    
    func getCoverImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = model.coverImageUrl else {
            completion(UIImage.placeholder)
            return
        }
        
        getImage(withURL: imageURL, completion: completion)
    }
    
    func cancelCoverLoading() {
        if fetchCoverTask != nil {
            logger.debug("cancelled image loading")
            fetchCoverTask?.cancel()
            fetchCoverTask = nil
            indicateCoverImageFinished()
        }
    }
    
    private func getImage(withURL imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        indicateCoverImageLoading()
        fetchCoverTask?.cancel()
        fetchCoverTask = imageService.downloadImage(fromURL: imageURL) { [weak self](img, _) in
            self?.indicateCoverImageFinished()
            if let img = img {
                completion(img)
            } else {
                completion(UIImage.placeholder)
            }
            self?.fetchCoverTask = nil
        }
    }
    
    private func indicateCoverImageLoading() {
        imageLoadingActivityIndicatorAnimating.onNext(true)
    }
    
    private func indicateCoverImageFinished() {
        imageLoadingActivityIndicatorAnimating.onNext(false)
    }
}
