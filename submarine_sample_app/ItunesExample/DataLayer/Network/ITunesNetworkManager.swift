//
//  ITunesNetworkService.swift
//  ItunesExample
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

class ITunesNetworkService: NetworkService {
    
    // MARK: - Properties
    let session: URLSession
    
    // MARK: - Methods
    init(session: URLSession) {
        self.session = session
    }
}
