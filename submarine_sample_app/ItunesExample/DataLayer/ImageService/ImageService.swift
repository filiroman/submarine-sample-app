//
//  ImageService.swift
//  ItunesExample
//
//  Created by Roman Filippov on 02.02.2021.
//

import Foundation
import UIKit

protocol ImageService {
    func downloadImage(fromURL url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask?
    func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceholder placeholder: UIImage?)
}
