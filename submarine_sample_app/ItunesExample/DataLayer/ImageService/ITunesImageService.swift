//
//  ITunesImageService.swift
//  ItunesExample
//
//  Created by Roman Filippov on 02.02.2021.
//

import Foundation
import UIKit

class ITunesImageService: ImageService {
    
    // MARK: - Properties
    var cachedImageForURL: [URL: UIImage]
    var cachedTaskForImageView: [UIImageView: URLSessionDataTask]
    
    let responseQueue: DispatchQueue?
    let session: URLSession
    
    // MARK: - Object Lifecycle
    init(responseQueue: DispatchQueue?,
         session: URLSession = .shared) {
        
        self.cachedImageForURL = [:]
        self.cachedTaskForImageView = [:]
        
        self.responseQueue = responseQueue
        self.session = session
    }
    
    // MARK: - Methods
    
    func downloadImage(fromURL url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask? {
        if let image = cachedImageForURL[url] {
            completion(image, nil)
            return nil
        }
        let dataTask = session.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                self.cachedImageForURL[url] = image
                self.dispatch(image: image, completion: completion)
            } else {
                self.dispatch(error: error, completion: completion)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceholder placeholder: UIImage?) {
        cachedTaskForImageView[imageView]?.cancel()
        imageView.image = placeholder
        
        cachedTaskForImageView[imageView] = downloadImage(fromURL: url) { [weak self] image, error in
            guard let strong = self else { return }
            strong.cachedTaskForImageView[imageView] = nil
            guard let image = image else {
                print("Set Image failed with error: " + String(describing: error))
                return
            }
            imageView.image = image
        }
    }
    
    private func dispatch(image: UIImage? = nil, error: Error? = nil, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let responseQueue = responseQueue else {
            completion(image, error)
            return
        }
        
        responseQueue.async { completion(image, error) }
    }
}
