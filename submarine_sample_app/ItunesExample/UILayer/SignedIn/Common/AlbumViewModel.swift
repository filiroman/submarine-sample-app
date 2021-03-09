//
//  AlbumViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 22.02.2021.
//

import Foundation
import RxSwift

protocol AlbumViewModel {
    var albumTitle: String { get }
    var artistTitle: String { get }
    var albumId: AlbumID { get }
    var coverImageUrl: URL? { get }
    
    var searchActivityIndicatorAnimating: BehaviorSubject<Bool> { get }

    func getPreviewImage(completion: @escaping (UIImage?) -> Void)
    func cancelCoverLoading()
}

class AlbumViewModelImpl: AlbumViewModel {
    var albumTitle: String {
        return model.albumName
    }
    var artistTitle: String {
        return model.artistName
    }
    var albumId: AlbumID {
        return model.itemID
    }
    
    var coverImageUrl: URL? {
        return model.artworkUrl
    }
    
    var searchActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    private let imageService: ImageService
    private let model: AlbumMediaItemModel
    
    private var task: URLSessionDataTask?
    
    init (model: AlbumMediaItemModel, imageService: ImageService) {
        self.model = model
        self.imageService = imageService
    }
        
    func getPreviewImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = model.artworkUrl else {
            completion(UIImage.placeholder)
            return
        }
        
        getImage(withURL: imageURL, completion: completion)
    }
    
    func cancelCoverLoading() {
        if task != nil {
            logger.debug("cancelled image loading")
            task?.cancel()
            task = nil
            indicateLoadingFinished()
        }
    }
    
    private func getImage(withURL imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        indicateLoading()
        task?.cancel()
        task = imageService.downloadImage(fromURL: imageURL) { [weak self](img, _) in
            self?.indicateLoadingFinished()
            if let img = img {
                completion(img)
            } else {
                completion(UIImage.placeholder)
            }
            self?.task = nil
        }
    }
    
    private func indicateLoading() {
        searchActivityIndicatorAnimating.onNext(true)
    }
    
    private func indicateLoadingFinished() {
        searchActivityIndicatorAnimating.onNext(false)
    }
}

extension AlbumViewModelImpl: Equatable {
    static func == (lhs: AlbumViewModelImpl, rhs: AlbumViewModelImpl) -> Bool {
        return lhs.albumTitle == rhs.albumTitle && lhs.artistTitle == rhs.artistTitle
    }
}
