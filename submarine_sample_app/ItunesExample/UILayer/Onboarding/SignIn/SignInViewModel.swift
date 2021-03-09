//
//  SignInViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import RxSwift

protocol SignInViewModel {
    var emailInput: BehaviorSubject<String> { get }
    var passwordInput: BehaviorSubject<Secret> { get }
    var errorMessages: Observable<ErrorMessage> { get }
    
    var emailInputEnabled: BehaviorSubject<Bool> { get }
    var passwordInputEnabled: BehaviorSubject<Bool> { get }
    var signInButtonEnabled: BehaviorSubject<Bool> { get }
    var signInActivityIndicatorAnimating: BehaviorSubject<Bool> { get }
    
    func signIn()
}

class SignInViewModelImpl: SignInViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository, signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
    }
    
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<Secret>(value: "")
    
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    let signInButtonEnabled = BehaviorSubject<Bool>(value: true)
    let signInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    @objc func signIn() {
        indicateSigningIn()
        let (email, password) = getEmailPassword()
        userSessionRepository.signIn(email: email, password: password) { [weak self](userSession, error) in
            guard let strong = self else { return }
            if let error = error {
                strong.indicateErrorSigningIn(error)
                return
            }
            if let userSession = userSession {
                strong.signedInResponder.signedIn(to: userSession)
            } else {
                strong.indicateErrorSigningIn(AppError.unknown)
            }
        }
    }
    
    func indicateSigningIn() {
        emailInputEnabled.onNext(false)
        passwordInputEnabled.onNext(false)
        signInButtonEnabled.onNext(false)
        signInActivityIndicatorAnimating.onNext(true)
    }
    
    func getEmailPassword() -> (String, Secret) {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            return (email, password)
        } catch {
            return ("", "")
        }
    }
    
    func indicateErrorSigningIn(_ error: Error) {
        errorMessagesSubject.onNext(ErrorMessage(title: "Sign In Failed".localized,
                                                 message: error.localizedDescription))
        emailInputEnabled.onNext(true)
        passwordInputEnabled.onNext(true)
        signInButtonEnabled.onNext(true)
        signInActivityIndicatorAnimating.onNext(false)
    }
}
