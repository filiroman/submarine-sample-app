//
//  SignUpViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import RxSwift

protocol SignUpViewModel {
    var nameInput: BehaviorSubject<String> { get }
    var emailInput: BehaviorSubject<String> { get }
    var passwordInput: BehaviorSubject<Secret> { get }
    var errorMessages: Observable<ErrorMessage> { get }
    
    var nameInputEnabled: BehaviorSubject<Bool> { get }
    var emailInputEnabled: BehaviorSubject<Bool> { get }
    var passwordInputEnabled: BehaviorSubject<Bool> { get }
    var signUpButtonEnabled: BehaviorSubject<Bool> { get }
    var signUpActivityIndicatorAnimating: BehaviorSubject<Bool> { get }
    
    func signUp()
}

class SignUpViewModelImpl: SignUpViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder
    
    let nameInput = BehaviorSubject<String>(value: "")
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<Secret>(value: "")
    
    let nameInputEnabled = BehaviorSubject<Bool>(value: true)
    let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    let signUpButtonEnabled = BehaviorSubject<Bool>(value: true)
    let signUpActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObservable()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
    }
    
    func signUp() {
        let (name, email, password) = getFieldValues()
        let newAccount = NewAccount(username: name,
                                    email: email,
                                    password: password)
        indicateSigningUp()
        userSessionRepository.signUp(newAccount: newAccount) { [weak self](userSession, error) in
            guard let strong = self else { return }
            if let error = error {
                strong.indicateErrorSigningUp(error)
                return
            }
            if let userSession = userSession {
                strong.signedInResponder.signedIn(to: userSession)
            } else {
                strong.indicateErrorSigningUp(AppError.unknown)
            }
        }
    }
    
    func getFieldValues() -> (String, String, Secret) {
        do {
            let name = try nameInput.value()
            let email = try emailInput.value()
            let password = try passwordInput.value()
            return (name, email, password)
        } catch {
            return ("", "", "")
        }
    }
    
    func indicateSigningUp() {
        nameInputEnabled.onNext(false)
        emailInputEnabled.onNext(false)
        passwordInputEnabled.onNext(false)
        signUpButtonEnabled.onNext(false)
        signUpActivityIndicatorAnimating.onNext(true)
    }
    
    func indicateErrorSigningUp(_ error: Error) {
        errorMessagesSubject.onNext(ErrorMessage(title: "Sign Up Failed".localized,
                                                 message: error.localizedDescription))
        nameInputEnabled.onNext(true)
        emailInputEnabled.onNext(true)
        passwordInputEnabled.onNext(true)
        signUpButtonEnabled.onNext(true)
        signUpActivityIndicatorAnimating.onNext(false)
    }
}
