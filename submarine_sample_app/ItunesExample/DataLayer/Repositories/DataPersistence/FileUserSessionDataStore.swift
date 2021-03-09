//
//  FileUserSessionDataStore.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

class FileUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    var docsURL: URL? {
        return FileManager
            .default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                          in: FileManager.SearchPathDomainMask.allDomainsMask).first
    }
    
    let sessionQueue = DispatchQueue(label: "FileUserSessionDataStore")
    
    // MARK: - Methods
    public init() {}
    
    public func readUserSession(completion: @escaping UserSessionCompletionHandler) {
        sessionQueue.async { [weak self] in
            guard let strong = self else { return }
            guard let docsURL = strong.docsURL else {
                DispatchQueue.main.async {
                    completion(nil, AppError.documentsDirNotFound)
                }
                return
            }
            let sessionFileUrl = docsURL.appendingPathComponent("user_session.json")
            guard FileManager.default.fileExists(atPath: sessionFileUrl.path) else {
                DispatchQueue.main.async {
                    completion(nil, AppError.userSessionNotFound)
                }
                return
            }
            do {
                let jsonData = try Data(contentsOf: sessionFileUrl)
                
                let decoder = JSONDecoder()
                let userSession = try decoder.decode(UserSession.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(userSession, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    public func save(userSession: UserSession, completion: @escaping UserSessionCompletionHandler) {
        sessionQueue.async { [weak self] in
            guard let strong = self else { return }
            guard let docsURL = strong.docsURL else {
                DispatchQueue.main.async {
                    completion(nil, AppError.documentsDirNotFound)
                }
                return
            }
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(userSession)
                try jsonData.write(to: docsURL.appendingPathComponent("user_session.json"))
                DispatchQueue.main.async {
                    completion(userSession, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
//    public func delete(userSession: UserSession, completion: @escaping UserSessionCompletionHandler) {
//        guard let docsURL = docsURL else {
//            completion(nil, AppError.documentsDirNotFound)
//            return
//        }
//        do {
//            try FileManager.default.removeItem(at: docsURL.appendingPathComponent("user_session.json"))
//            completion(userSession, nil)
//        } catch {
//            completion(nil, error)
//            return
//        }
//    }
}
