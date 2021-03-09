//
//  LaunchViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import RxSwift

class LaunchViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let notSignedInResponder: NotSignedInResponder
    let signedInResponder: SignedInResponder
    
    public var errorMessages: Observable<ErrorMessage> {
        return self.errorMessagesSubject.asObserver()
    }
    private let errorMessagesSubject: PublishSubject<ErrorMessage> =
        PublishSubject()
    
    public let errorPresentation: BehaviorSubject<ErrorPresentation?> =
        BehaviorSubject(value: nil)
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                notSignedInResponder: NotSignedInResponder,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.notSignedInResponder = notSignedInResponder
        self.signedInResponder = signedInResponder
    }
    
    public func loadUserSession() {
        userSessionRepository.readUserSession { [weak self](userSession, error) in
            guard let strong = self else { return }
            if let userSession = userSession {
                strong.goToNextScreen(userSession: userSession)
            } else if let error = error {
                var shouldShowError = true
                if let appError = error as? AppError,
                   appError == .userSessionNotFound {
                    shouldShowError = false
                }
                if shouldShowError {
                    strong.indicateSignInError(error)
                }
                strong.goToNextScreen(userSession: nil)
            } else {
                strong.indicateSignInError(AppError.unknown)
                strong.goToNextScreen(userSession: userSession)
            }
        }
    }
    
    func present(errorMessage: ErrorMessage) {
        goToNextScreenAfterErrorPresentation()
        errorMessagesSubject.onNext(errorMessage)
    }
    
    func goToNextScreenAfterErrorPresentation() {
        _ = errorPresentation
            .filter { $0 == .dismissed }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.goToNextScreen(userSession: nil)
            })
    }
    
    func goToNextScreen(userSession: UserSession?) {
        switch userSession {
        case .none:
            notSignedInResponder.notSignedIn()
        case .some(let userSession):
            signedInResponder.signedIn(to: userSession)
        }
    }
    
    func indicateSignInError(_ error: Error) {
        let errorMessage = ErrorMessage(title: "Sign In Error".localized,
                                        message: "Sorry, we couldn't determine if you are already signed in. Please sign in or sign up.".localized)
        self.present(errorMessage: errorMessage)
    }
}

