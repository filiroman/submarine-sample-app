//
//  String+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 18.01.2021.
//

import Foundation

extension String {
    var localized: String {
        let retValue = "Localized not found for: \(self)"
        return NSLocalizedString(self, value: retValue, comment: "")
    }
}
