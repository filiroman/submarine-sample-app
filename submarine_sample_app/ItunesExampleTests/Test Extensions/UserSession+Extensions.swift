//
//  UserSession+Extensions.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import Foundation
@testable import ItunesExample

extension UserSession {
    class func makeFakeSession() -> UserSession {
        let userProfile = UserProfile(username: "test", email: "test")
        let remoteSession = RemoteUserSession(token: "Test")
        let userSession = UserSession(profile: userProfile, remoteSession: remoteSession)
        return userSession
    }
}
