//
//  UserSessionRepository.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

typealias UserSessionCompletionHandler = (UserSession?, Error?) -> Void

protocol UserSessionRepository {
    
    func readUserSession(completion: @escaping UserSessionCompletionHandler)
    func signUp(newAccount: NewAccount, completion: @escaping UserSessionCompletionHandler)
    func signIn(email: String, password: String, completion: @escaping UserSessionCompletionHandler)
}
