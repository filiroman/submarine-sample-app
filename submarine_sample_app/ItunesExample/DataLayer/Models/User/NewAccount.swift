//
//  NewAccount.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

public typealias Secret = String

public struct NewAccount: Codable {
    
    // MARK: - Properties
    public let username: String
    public let email: String
    public let password: Secret
    
    // MARK: - Methods
    public init(username: String,
                email: String,
                password: Secret) {
        self.username = username
        self.email = email
        self.password = password
    }
}

