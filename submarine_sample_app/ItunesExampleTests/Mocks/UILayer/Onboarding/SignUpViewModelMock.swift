//
//  SignUpViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 05.03.2021.
//

import Foundation
import RxSwift
@testable import ItunesExample

class SignUpViewModelMock: SignUpViewModel {
    let nameInput = BehaviorSubject<String>(value: "")
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<Secret>(value: "")
    
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    let nameInputEnabled = BehaviorSubject<Bool>(value: true)
    let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    let signUpButtonEnabled = BehaviorSubject<Bool>(value: true)
    let signUpActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Mock Properties
    var signUpCalled = false
    
    func signUp() {
        signUpCalled = true
    }
    
    
}
