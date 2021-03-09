//
//  ErrorMessage+Extension.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation
@testable import ItunesExample

extension ErrorMessage {
    static var testMessage: ErrorMessage {
        return ErrorMessage(title: "Test", message: "Test")
    }
}
