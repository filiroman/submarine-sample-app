//
//  UICollectionViewCell+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func makeCellShadows(radius: CGFloat) {
        self.contentView.layer.cornerRadius = 0.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
