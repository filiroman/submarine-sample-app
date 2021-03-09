//
//  SignedInDependencyContainer.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import UIKit

class SignedInDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let userSessionRepository: UserSessionRepository
    let mainViewModel: MainViewModel
    
    // Context
    let userSession: UserSession
    let signedInViewModel: SignedInViewModel
    
    // Longed-lived dependencies
    let mediaAPI: MediaLibraryRemoteAPI
    let imageService: ImageService
    
    // MARK: - Methods
    public init(userSession: UserSession, appDependencyContainer: AppDependencyContainer) {
        // Declared here because should be called only once
        func makeNetworkService() -> NetworkService {
            return ITunesNetworkService(session: URLSession.shared)
        }
        
        func makeMediaAPI() -> MediaLibraryRemoteAPI {
            return ITunesMediaLibraryRemoteAPI(networkService: makeNetworkService())
        }
        
        func makeImageService() -> ImageService {
            return ITunesImageService(responseQueue: .main)
        }
        
        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel(userSession: userSession)
        }
        
        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.mainViewModel = appDependencyContainer.sharedMainViewModel
        
        self.userSession = userSession
        self.signedInViewModel = makeSignedInViewModel()
        
        self.mediaAPI = makeMediaAPI()
        self.imageService = makeImageService()
    }
    
    // Signed-in
    public func makeSignedInViewController() -> SignedInViewController {
        let searchViewController = makeSearchViewController()
        
        let albumDetailsViewControllerFactory = { (viewModel: AlbumViewModel) in
            return self.makeAlbumDetailsViewController(viewModel: viewModel)
        }
        
        return SignedInViewController(viewModel: signedInViewModel,
                                      searchViewController: searchViewController,
                                      albumDetailsViewControllerFactory: albumDetailsViewControllerFactory)
    }
    
    // Search
    func makeAlbumViewModel(model: AlbumMediaItemModel) -> AlbumViewModel {
        return AlbumViewModelImpl(model: model, imageService: imageService)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        let albumViewModelFactory = { (model: AlbumMediaItemModel) in
            return self.makeAlbumViewModel(model: model)
        }
        
        return SearchViewModelImpl(mediaAPI: mediaAPI,
                                   responder: signedInViewModel,
                                   makeAlbumViewModel: albumViewModelFactory)
    }
    
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }
    
    // Album Details
    func makeAlbumDetailsViewModel(viewModel: AlbumViewModel) -> AlbumDetailsViewModel {
        return AlbumDetailsViewModelImpl(model: viewModel, mediaAPI: mediaAPI, imageService: imageService)
    }
    
    func makeAlbumDetailsViewController(viewModel: AlbumViewModel) -> AlbumDetailsViewController {
        let detailsVm = makeAlbumDetailsViewModel(viewModel: viewModel)
        return AlbumDetailsViewController(viewModel: detailsVm)
    }
}
