//
//  ErrorMessage.swift
//  ItunesExample
//
//  Created by Roman Filippov on 20.01.2021.
//

import Foundation

// This struct is used to present errors in alert views
public struct ErrorMessage: Error {

    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let message: String

    // MARK: - Methods
    public init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}

extension ErrorMessage {
    init(error: Error) {
        self.init(title: "Error!".localized, message: error.localizedDescription)
    }
}

extension ErrorMessage: Equatable {

    public static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
