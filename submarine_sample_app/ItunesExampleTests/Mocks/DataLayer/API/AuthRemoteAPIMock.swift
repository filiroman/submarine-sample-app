//
//  AuthRemoteAPIMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import Foundation
@testable import ItunesExample

class AuthRemoteAPIMock: AuthRemoteAPI {
    var signInCalled = false
    var signUpCalled = false
    var error: Error?
    var userSession: UserSession?
    
    func signIn(username: String, password: String, completion: @escaping UserSessionCompletionHandler) {
        signInCalled = true
        completion(userSession, error)
    }
    
    func signUp(account: NewAccount, completion: @escaping UserSessionCompletionHandler) {
        signUpCalled = true
        completion(userSession, error)
    }
}
