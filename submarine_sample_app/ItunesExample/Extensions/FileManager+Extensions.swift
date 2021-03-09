//
//  FileManager+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
