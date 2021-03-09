//
//  SignInViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import RxSwift
@testable import ItunesExample

class SignInViewModelMock: SignInViewModel {
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
    
    // MARK: - Mock Properties
    var signInCalled = false
    
    func signIn() {
        signInCalled = true
    }
    
    
}
