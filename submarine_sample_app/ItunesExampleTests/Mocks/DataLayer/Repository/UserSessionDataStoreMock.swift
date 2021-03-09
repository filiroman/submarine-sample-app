//
//  UserSessionDataStoreMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import Foundation
@testable import ItunesExample

class UserSessionDataStoreMock: UserSessionDataStore {
    var readUserSessionCalled = false
    var saveUserSessionCalled = false
    var error: Error?
    var userSession: UserSession?
    
    func readUserSession(completion: @escaping UserSessionCompletionHandler) {
        readUserSessionCalled = true
        completion(userSession, error)
    }
    
    func save(userSession: UserSession, completion: @escaping UserSessionCompletionHandler) {
        saveUserSessionCalled = true
        completion(userSession, error)
    }
}
