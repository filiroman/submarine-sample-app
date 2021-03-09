//
//  NSError+Extension.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation

extension NSError {
    class var testError: NSError {
        return NSError(domain: "Test error!", code: -1, userInfo: nil)
    }
}
