//
//  AppError.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

enum AppError: Error, CustomStringConvertible, LocalizedError {
    case unknown
    // Local errors
    case documentsDirNotFound
    case wrongUsernameOrPassword
    case userSessionNotFound
    case invalidCredentials
    
    var description: String {
        switch self {
        case .unknown:
            return "Unknown error".localized
        case .documentsDirNotFound:
            return "App documents directory not found".localized
        case .wrongUsernameOrPassword:
            return "Wrong username or password".localized
        case .userSessionNotFound:
            return "User session not found".localized
        case .invalidCredentials:
            return "Invalid credentials entered".localized
        }
    }
    
    var errorDescription: String? {
        return description
    }
}
