//
//  SignedInResponder.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}
