//
//  AppDependencyContainer.swift
//  ItunesExample
//
//  Created by Roman Filippov on 18.01.2021.
//

import Foundation

class AppDependencyContainer {
    
    // MARK: - Properties
    // Long-living dependencies
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel
    
    // MARK: - Methods
    public init() {
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()
            return ITunesUserSessionRepository(dataStore: dataStore,
                                              remoteAPI: remoteAPI)
        }
        
        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FileUserSessionDataStore()
        }
        
        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }
        
        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        // Initializing long-living dependencies
        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
    }
    
    // Main
    // Factories needed to create a MainViewController.
    
    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()
        
        let onboardingViewControllerFactory = {
            return self.makeOnboardingViewController()
        }
        
        let signedInViewControllerFactory = { (userSession: UserSession) in
            return self.makeSignedInViewController(session: userSession)
        }
        
        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
                                  signedInViewControllerFactory: signedInViewControllerFactory)
    }
    
    // Launching
    
    public func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                               notSignedInResponder: sharedMainViewModel,
                               signedInResponder: sharedMainViewModel)
    }
    
    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(viewModel: makeLaunchViewModel())
    }
    
    // Onboarding (signed-out)
    // Factories needed to create an OnboardingViewController.
    
    public func makeOnboardingViewController() -> OnboardingViewController {
        let dependencyContainer = OnboardingDependencyContainer(appDependencyContainer: self)
        return dependencyContainer.makeOnboardingViewController()
    }
    
    // Signed-in
    
    public func makeSignedInViewController(session: UserSession) -> SignedInViewController {
        let dependencyContainer = makeSignedInDependencyContainer(session: session)
        return dependencyContainer.makeSignedInViewController()
    }
    
    public func makeSignedInDependencyContainer(session: UserSession) -> SignedInDependencyContainer {
        return SignedInDependencyContainer(userSession: session, appDependencyContainer: self)
    }
}
