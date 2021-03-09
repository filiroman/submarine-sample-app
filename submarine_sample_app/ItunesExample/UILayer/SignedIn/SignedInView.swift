//
//  SignedInView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation

enum SignedInView {
    
    case search
    case albumDetails(model: AlbumViewModel)
}

extension SignedInView: Equatable {
    
    public static func == (lhs: SignedInView, rhs: SignedInView) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search):
            return true
        default:
            return false
        }
    }
}
