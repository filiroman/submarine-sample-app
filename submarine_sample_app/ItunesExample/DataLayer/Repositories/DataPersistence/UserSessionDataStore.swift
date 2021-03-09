//
//  UserSessionDataStore.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

protocol UserSessionDataStore {
    
    func readUserSession(completion: @escaping UserSessionCompletionHandler)
    func save(userSession: UserSession, completion: @escaping UserSessionCompletionHandler)
    // func delete(userSession: UserSession, completion: @escaping UserSessionCompletionHandler)
}
