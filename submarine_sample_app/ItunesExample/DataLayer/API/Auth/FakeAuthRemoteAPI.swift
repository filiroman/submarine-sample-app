//
//  FakeAuthRemoteAPI.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

public struct FakeAuthRemoteAPI: AuthRemoteAPI {
    
    // MARK: - Methods
    public init() {}
    
    func signIn(username: String, password: String, completion: @escaping UserSessionCompletionHandler) {
        guard username == "test" && password == "test" else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(nil, AppError.wrongUsernameOrPassword)
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let profile = UserProfile(username: "Test",
                                      email: "Test")
            let remoteUserSession = RemoteUserSession(token: "Test")
            let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
            completion(userSession, nil)
        }
    }
    
    func signUp(account: NewAccount, completion: @escaping UserSessionCompletionHandler) {
        let profile = UserProfile(username: account.username,
                                  email: account.email)
        let remoteUserSession = RemoteUserSession(token: "Test")
        let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            completion(userSession, nil)
        }
    }
}
