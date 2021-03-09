//
//  ImageServiceMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import UIKit
@testable import ItunesExample

class ImageServiceMock: ImageService {
    var downloadImageCalled = false
    var setImageCalled = false
    
    var returnImage: UIImage?
    var returnError: Error?
    
    func downloadImage(fromURL url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask? {
        downloadImageCalled = true
        if let returnImage = returnImage {
            completion(returnImage, nil)
        } else if let returnError = returnError {
            completion(nil, returnError)
        }
        return MockURLSessionDataTask(completionHandler: { (_, _, _) in}, url: url, queue: nil)
    }
    
    func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceholder placeholder: UIImage?) {
        setImageCalled = true
    }
}
