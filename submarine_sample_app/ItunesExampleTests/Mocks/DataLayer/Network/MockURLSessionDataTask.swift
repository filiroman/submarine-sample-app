//
//  MockURLSessionDataTask.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    
    var calledResume = false
    var calledCancel = false
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, url: URL, queue: DispatchQueue?) {
        if let queue = queue {
            self.completionHandler = { data, response, error in
                queue.async {
                    completionHandler(data, response, error)
                }
            }
        } else {
            self.completionHandler = completionHandler
        }
        self.url = url
        super.init()
    }
    
    override func resume() {
        calledResume = true
    }
    
    override func cancel() {
        calledCancel = true
    }
}
