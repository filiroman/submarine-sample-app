//
//  UIView+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 06.02.2021.
//

import Foundation
import UIKit

extension UIView {
    public static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - Shadows and Corners
extension UIView {
    
    func roundUpperCorners(radius: CGFloat) {
        roundCorners(radius: radius)
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func roundDownCorners(radius: CGFloat) {
        roundCorners(radius: radius)
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func roundCorners(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func makeShadows(radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.5
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func makeShadowsAndRoundCorners(radius: CGFloat = 10.0) {
        roundCorners(radius: radius)
        makeShadows(radius: radius)
    }
}
