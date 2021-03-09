//
//  UserSession.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

class UserSession: Codable {
    
    // MARK: - Properties
    public let profile: UserProfile
    public let remoteSession: RemoteUserSession
    
    // MARK: - Methods
    public init(profile: UserProfile, remoteSession: RemoteUserSession) {
        self.profile = profile
        self.remoteSession = remoteSession
    }
}

extension UserSession: Equatable {
    
    public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile == rhs.profile &&
            lhs.remoteSession == rhs.remoteSession
    }
}

