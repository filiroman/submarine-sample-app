//
//  ITunesUserSessionRepository.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

class ITunesUserSessionRepository: UserSessionRepository {
    
    // MARK: - Properties
    let dataStore: UserSessionDataStore
    let remoteAPI: AuthRemoteAPI
    
    // MARK: - Methods
    public init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func readUserSession(completion: @escaping UserSessionCompletionHandler) {
        dataStore.readUserSession(completion: completion)
    }
    
    public func signUp(newAccount: NewAccount, completion: @escaping UserSessionCompletionHandler) {
        guard !newAccount.email.isEmpty,
              !newAccount.password.isEmpty,
              !newAccount.username.isEmpty else {
            completion(nil, AppError.invalidCredentials)
            return
        }
        remoteAPI.signUp(account: newAccount) { [weak self](userSession, error) in
            guard let strong = self else { return }
            if let error = error {
                completion(nil, error)
                return
            }
            if let userSession = userSession {
                strong.dataStore.save(userSession: userSession, completion: completion)
            } else {
                completion(nil, AppError.unknown)
            }
        }
    }
    
    public func signIn(email: String, password: String, completion: @escaping UserSessionCompletionHandler) {
        guard !email.isEmpty,
              !password.isEmpty else {
            completion(nil, AppError.invalidCredentials)
            return
        }
        remoteAPI.signIn(username: email, password: password) { [weak self](userSession, error) in
            guard let strong = self else { return }
            if let error = error {
                completion(nil, error)
                return
            }
            if let userSession = userSession {
                strong.dataStore.save(userSession: userSession, completion: completion)
            } else {
                completion(nil, AppError.unknown)
            }
        }
    }
}

