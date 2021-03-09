//
//  MockURLSession.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

class MockURLSession: URLSession {
    var queue: DispatchQueue?
    
    func givenDispatchQueue() {
        queue = DispatchQueue(label: "com.romanfilippov.itunesExample.mockURLSessionQueue")
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url, queue: queue)
    }
}

