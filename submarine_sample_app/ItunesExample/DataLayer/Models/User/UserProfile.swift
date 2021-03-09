//
//  UserProfile.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

public struct UserProfile: Codable, Equatable {
    
    // MARK: - Properties
    let username: String
    let email: String
    
    // This is intented to serve as JSON keys for profile retrieved from the backend, not used for now
    private enum CodingKeys: String, CodingKey {
        case username = "user_name"
        case email
    }
}

