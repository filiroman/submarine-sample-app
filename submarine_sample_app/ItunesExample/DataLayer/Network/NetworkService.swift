//
//  NetworkService.swift
//  ItunesExample
//
//  Created by Roman Filippov on 26.01.2021.
//

import Foundation

public typealias JSON = [String: Any]

public enum NetworkResult<T: Decodable> {
    case success(T)
    case failure(Error)
}

protocol NetworkService {
    func loadRequest<ResponseType: Decodable>(url: URL,
                                              parameters: [String: String],
                                              responseQueue: DispatchQueue,
                                              completion: @escaping(NetworkResult<ResponseType>) -> Void) -> URLSessionDataTask
}

extension NetworkService {
    func loadRequest<ResponseType: Decodable>(url: URL, parameters: [String: String], completion: @escaping(NetworkResult<ResponseType>) -> Void) -> URLSessionDataTask {
        loadRequest(url: url, parameters: parameters, responseQueue: .main, completion: completion)
    }
    
    func loadRequest<ResponseType: Decodable>(url: URL, completion: @escaping(NetworkResult<ResponseType>) -> Void) -> URLSessionDataTask {
        loadRequest(url: url, parameters: [:], responseQueue: .main, completion: completion)
    }
}
