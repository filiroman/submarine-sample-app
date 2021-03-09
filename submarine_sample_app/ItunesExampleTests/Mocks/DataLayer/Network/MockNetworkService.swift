//
//  MockNetworkService.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation
@testable import ItunesExample

class MockNetworkService: NetworkService {
    var networkError: Error?
    var calledURL: URL?
    var calledParams: [String: String]?
    var returnedData: Decodable?
    
    let completionHandler = { (data: Data?, response: URLResponse?, error: Error?) in }
    
    func loadRequest<ResponseType: Decodable>(url: URL, parameters: [String: String], responseQueue: DispatchQueue, completion: @escaping(NetworkResult<ResponseType>) -> Void) -> URLSessionDataTask {
        calledURL = url
        calledParams = parameters
        if let networkError = networkError {
            responseQueue.async {
                completion(.failure(networkError))
            }
        } else if let returnedData = returnedData {
            responseQueue.async {
                completion(.success(returnedData as! ResponseType))
            }
        } else {
            responseQueue.async {
                completion(.failure(NSError(domain: "Test", code: -1, userInfo: nil)))
            }
        }
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url, queue: responseQueue)
    }
}
