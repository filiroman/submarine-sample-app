//
//  UIImage+Extensions.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 06.03.2021.
//

import Foundation
import UIKit

extension UIImage {
    static func testImage(withName name: String) -> UIImage! {
        return UIImage(contentsOfFile: Bundle(for: TestBundleClass.self).path(forResource: name, ofType: nil)!)!
    }
    
    static var testImage: UIImage {
        return UIImage.testImage(withName: "sample.png")
    }
}

private class TestBundleClass { }
