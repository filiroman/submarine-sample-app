//
//  AuthRemoteAPI.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

protocol AuthRemoteAPI {
    
    func signIn(username: String, password: String, completion: @escaping UserSessionCompletionHandler)
    func signUp(account: NewAccount, completion: @escaping UserSessionCompletionHandler)
}
