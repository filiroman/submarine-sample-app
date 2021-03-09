//
//  OnboardingDependencyContainer.swift
//  ItunesExample
//
//  Created by Roman Filippov on 12.11.2020.
//

import Foundation

class OnboardingDependencyContainer {
    
    // MARK: - Properties
    // From parent container
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel
    
    // Long-living dependencies
    let sharedOnboardingViewModel: OnboardingViewModel
    
    // MARK: - Methods
    init(appDependencyContainer: AppDependencyContainer) {
        func makeOnboardingViewModel() -> OnboardingViewModel {
            return OnboardingViewModel()
        }
        
        self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
        
        self.sharedOnboardingViewModel = makeOnboardingViewModel()
    }
    
    // On-boarding (signed-out)
    // Factories needed to create an OnboardingViewController.
    public func makeOnboardingViewController() -> OnboardingViewController {
        let welcomeViewController = makeWelcomeViewController()
        let signInViewController = makeSignInViewController()
        let signUpViewController = makeSignUpViewController()
        return OnboardingViewController(viewModel: sharedOnboardingViewModel,
                                        welcomeViewController: welcomeViewController,
                                        signInViewController: signInViewController,
                                        signUpViewController: signUpViewController)
    }
    
    // Welcome
    public func makeWelcomeViewModel() -> WelcomeViewModel {
        return WelcomeViewModelImpl(goToSignUpNavigator: sharedOnboardingViewModel,
                                goToSignInNavigator: sharedOnboardingViewModel)
    }
    
    public func makeWelcomeViewController() -> WelcomeViewController {
        return WelcomeViewController(viewModel: makeWelcomeViewModel())
    }
    
    // Sign In
    public func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModelImpl(userSessionRepository: sharedUserSessionRepository,
                               signedInResponder: sharedMainViewModel)
    }
    
    public func makeSignInViewController() -> SignInViewController {
        return SignInViewController(viewModel: makeSignInViewModel())
    }
    
    // Sign Up
    public func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModelImpl(userSessionRepository: sharedUserSessionRepository,
                               signedInResponder: sharedMainViewModel)
    }
    
    public func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController(viewModel: makeSignUpViewModel())
    }
}

