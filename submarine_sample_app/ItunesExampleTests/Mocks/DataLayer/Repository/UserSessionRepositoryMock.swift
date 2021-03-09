//
//  UserSessionRepositoryMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import Foundation
@testable import ItunesExample

class UserSessionRepositoryMock: UserSessionRepository {
    
    var userSession: UserSession!
    var readUserSessionError: Error?
    
    func readUserSession(completion: @escaping UserSessionCompletionHandler) {
        if let error = readUserSessionError {
            completion(nil, error)
            return
        }
        completion(userSession, nil)
    }
    
    func signUp(newAccount: NewAccount, completion: @escaping UserSessionCompletionHandler) {
        if let error = readUserSessionError {
            completion(nil, error)
            return
        }
        completion(userSession, nil)
    }
    
    func signIn(email: String, password: String, completion: @escaping UserSessionCompletionHandler) {
        if let error = readUserSessionError {
            completion(nil, error)
            return
        }
        completion(userSession, nil)
    }
}
