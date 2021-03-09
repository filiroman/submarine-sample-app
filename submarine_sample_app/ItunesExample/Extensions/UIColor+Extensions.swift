//
//  UIColor+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 18.01.2021.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
}
